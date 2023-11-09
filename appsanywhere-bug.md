---
title: Security Vulnerabilities in AppsAnywhere
layout: default
---

If you're affiliated with one of "over 250" universities, you're probably
familiar with AppsAnywhere, a system these universities use to deliver software
to users (on both university-owned and personal computers) on a self-service
basis.

On the surface, it's a pretty nifty system: after a one-time installation
process, a user can go to their university's AppsAnywhere webpage (e.g.
https://appstore.st-andrews.ac.uk), select an app, and it launches on
the user's machine. Magic!

I spent some time digging into how this all works, and found a few bugs in the
process.

This report focuses on the macOS version of AppsAnywhere, but some of it
applies to Windows too; I call this out where appropriate.

## Architecture overview

AppsAnywhere consists of two pieces (relevant here):

- The AppsAnywhere server, a web server hosted by the university or
  AppsAnywhere themselves.
- The AppsAnywhere client, a piece of software, available for macOS and
  Windows, installed on the user machine. (For university machines, this'll
  be pre-installed however IT normally installs software; for user-owned
  machines, users are guided through the installation when they first use
  AppsAnywhere.)

To launch an app, a user navigates to their university's AppsAnywhere server
in a browser. The web page communicates with the client to determine some
information about the system (a process called "validation"), then shows the
user a list of apps they can launch.

There are a number of ways AppsAnywhere can "launch" an app, some of which
take place solely within the browser. But the one we're interested in is the
ability to launch a native app - which the user may or may not already have
installed - on the user's device.

## How does the website tell the local client to install something? (CVE-2023-41137)

The AppsAnywhere website communicates with the AppsAnywhere client by
instructing the browser to navigate to URLs like the following:

```
software2hub://RpLE22+gvQBSQC0oHGDNQSGnjf++3j8optf1Gt3vBt8+dV32jhakCBqOK5Re1VJNodK/F2damHJNx/qYH4iEc6WwuWTXXsSWhZJT7FNIYVdPMFZfI2xf+uBRsPD3Z0AoeDs7E5hnJ4N/I6vtfQQsaJ2WA74O1YPrNnm3FBYk6CDX/dKYe/4N/+HE6dtXYDY7qc2Pn8e8ZE6gs0jhBS7zmm0akf1aiHxqq7BEsGpDN9QgvPB0tXdi78lnTFJoUN7SAFPtd5ZbXqls5PW2vqGJ06kvLCroxvd+7/zyOPRRvBEnmOnodO0NNX/oK7V9xWOj0sgYlHtr8o/2Yo54LuLJwbgSF7wbMzkuh+NSXdqvjCmcd8j+fG7PeWurggSttGwhB+MZ7cvbkDNNDegWIkRaxdBQGAm0Pe/C3oKwL2yWwF8v6CStN9W+vBsey4J9/KYv
```

The AppsAnywhere client registers itself as a handler for the
`software2hub://`[^1] URL scheme, causing it to open and handle the message when
a browser navigates to it.

[^1]: This comes from Software2, a former name for the company now called AppsAnywhere.

The message is a base64-encoded, AES-encrypted(!), JSON string. Because the
AppsAnywhere client must be able to decrypt the message, it contains a copy of
the key; some mild obfuscation is present, but ultimately any key embedded in
the client will be extractable with reverse engineering tools. Extracting the
key and using it to decode the message, we get this (pretty printed, download
URL for proprietary software redacted):

```
{
    "client-action-request": {
        "institution-id": "dueE8bZ10F",
        "message-format": "1.0",
        "action": "application-launch",
        "application-type": "mac-deployment",
        "request-data": {
            "download-url": "https://appstore.st-andrews.ac.uk/[redacted].pkg",
            "download-type": 20,
            "executable-name": "/Applications/IBM SPSS Statistics/SPSS Statistics.app"
        }
    }
}
```

The AppsAnywhere client checks if something exists at the path indicated by
`executable-name`; if not, it downloads the pkg file from `download-url` and
installs it (with root privileges!) through Apple's `installer` tool. Apple's
`pkg` format supports running arbitrary scripts during the installation
process, so installing an attacker-controlled pkg file is as good as arbitrary
code execution.

Nothing (beyond the symmetric AES encryption) serves to verify that the
installation request was legitimate; an attacker could convince a user to
navigate to a `software2hub://` link (e.g. though a link on a web page or
email) and install an arbitrary pkg file on their machine. This attack could be
used as an RCE with a social engineering component; in most browsers, an
attacker would need to convince the user to click through a confirmation prompt
such as "allow this website to open AppsAnywhere?" that an attacker would need
to convince a user to click through. It could also be used as a local privilege
escalation attack for an attacker with non-root access to the machine (e.g. a
student on a university-owned computer).

On Windows, a similar attack (with a different `application-type`) is possible,
but only gains code execution as the victim's user, not administrator privileges.

## Wait, it runs as root? (CVE-2023-41138)

Yes! Despite the AppsAnywhere client being invoked as the user, the pkg file
may need to be installed as root. How does that work?

On macOS, AppsAnywhere uses a service called `com.s2.uk.SMJobBlessHelper` to
allow the client to install software as root. Unfortunately, this service does
no security checking; it simply accepts command strings over Apple's XPC
mechanism, and runs them as root.

Thus, an attacker with the ability to run a program as any user on a macOS
machine with AppsAnywhere installed is able to trivially gain root privileges.
This is especially likely to be an issue on computers universities provide in
libraries and the like, though I'm not sure how common macOS is there.

This vulnerability does not exist on Windows. There, the AppsAnywhere client is
fully unprivileged, and privileged installation - where necessary - is handled
via a third-party program called [Cloudpaging][cp] installed alongside the
AppsAnywhere client. I'm told Cloudpaging does its own signature checking
before it does anything, though I haven't verified this.

[cp]: https://www.numecent.com/cloudpaging/

## The fix, round one

In July 2020, I reported CVE-2023-41137 to my university, who passed it on
to AppsAnywhere; unfortunately I was not party to the resulting discussions.
In August 2023, I checked back to discover a partial fix.

Presumably in response to this report, the macOS AppsAnywhere client was
updated; judging by changelogs, I believe this was client 1.4.0 released in
November 2020. It now refuses to accept `application-launch` requests passed
directly to the URL handler; instead, app launches on macOS use the following
protocol:

1. It sends a request to the AppsAnywhere client via a `software2hub://` URL
   like before, but the URL decodes to something like the following:
   ```
   {
       "client-action-request": {
           "institution-id": "dueE8bZ10F",
           "message-format": "1.0",
           "action": "retrieve-message",
           "request-data": {
               "message-id": "0123456789abcdef0123456789abcdef",
               "request-url": "https://appstore.st-andrews.ac.uk:443/api/client/get-request-message"
           }
       }
   }
   ```
2. The client sends an HTTP POST request to the `request-url`, passing the
   `message-id`. (The body of this post request is encoded as form data, with a
   `message` field containing encrypted base64 data using the same key; it's
   not immediately clear what purpose this serves.)
3. The server responds with JSON something like this:
   ```
   {
       "message-response": {
           "response-data": {
               "client-message": "software2hub://RpLE22+gvQBSQC0oHGDNQSGnjf++3j8optf1Gt3vBt8+dV32jhakCBqOK5Re1VJNodK/F2damHJNx/qYH4iEc6WwuWTXXsSWhZJT7FNIYVdPMFZfI2xf+uBRsPD3Z0AoeDs7E5hnJ4N/I6vtfQQsaJ2WA74O1YPrNnm3FBYk6CDX/dKYe/4N/+HE6dtXYDY7qc2Pn8e8ZE6gs0jhBS7zmm0akf1aiHxqq7BEsGpDN9QgvPB0tXdi78lnTFJoUN7SAFPtd5ZbXqls5PW2vqGJ06kvLCroxvd+7/zyOPRRvBEnmOnodO0NNX/oK7V9xWOj0sgYlHtr8o/2Yo54LuLJwbgSF7wbMzkuh+NSXdqvjCmcd8j+fG7PeWurggSttGwhB+MZ7cvbkDNNDegWIkRaxdBQGAm0Pe/C3oKwL2yWwF8v6CStN9W+vBsey4J9/KYv"
           },
           "result": "success"
       }
   }
   ```

The client then decodes the `client-message` (which contains an
`application-launch` request) and proceeds as before.

Presumably the intent is that, by fetching the launch request directly from the
server, the client can be sure it's not malicious. Unfortunately, the client
doesn't check that the `request-url` is in fact any server in particular, so
the attacker can simply set up their own server that responds to POST requests
with the appropriate JSON, create a `software2hub://` URL with `request-url`
pointing there, and convince a user to click that URL as before.

The "retrieve-message" mechanism doesn't seem to be used for app launches on
Windows[^2], so this change did not affect the Windows client.

[^2]: The Windows client does, however, support handling `retrieve-message` requests; I'm told it's used in "very specific and relatively rare operations". In any case, the Windows client still accepted launch requests sent directly, so the presence of the mechanism isn't relevant to us here.

## The fix, round 2

In August 2023, I reported to my university that CVE-2023-41137 was still
exploitable, and reported CVE-2023-41138 for the first time. This time, I
was kept in the loop as a fix was coordinated.

AppsAnywhere has now released client versions 1.6.1 and 2.0.1 (both versions
for both macOS and Windows; 1.6.1 is available for universities that haven't
moved to client 2.0.0 yet), with the following fixes:

- For CVE-2023-41137, the client now verifies public-key signatures on
  messages, in addition to the existing AES cryptography.
- For CVE-2023-41138, `com.s2.uk.SMJobBlessHelper` verifies that its caller
  has been codesigned by AppsAnywhere.

Some details on their crypto scheme (as best I can tell from static analysis;
my university isn't running the updated server yet):

- Each university gets assigned a Curve25519 public key.
- The client obtains this public key from AppsAnywhere's "central API" endpoint
  https://api.software2.com/clients/appsanywhere/dueE8bZ10F/signing/keys.json.
  The string `dueE8bZ10F` is the "institution ID"; the client reads this from
  the message and requests the corresponding key, so any AppsAnywhere client
  will accept installation requests from any university's server.

[^3]: That domain belongs to American Airlines!

To be honest, I'm not completely happy with either fix.

Their implementation of public-key cryptography trusts any university using
AppsAnywhere, so an attacker who gains access to one university's AppsAnywhere
installation gets RCE on every university's AppsEverywhere users; in my view, a
better solution would be to move the app selection process out of the browser
into a native app, so any launch request has the user's affirmative consent
by definition.

Keeping the existing SMJobBlessHelper architecture, but adding a public key
check, results in a large attack surface; any number of bugs in the
AppsAnywhere client (which is running as the potentially untrusted user, and
thus in a hostile environment) could result in LPE. Ideally, the privileged
component would independently verify that the request came from a trusted
university.

(These two suggested approaches might sound a little contradictory, but I
believe they're actually orthogonal. Ultimately, AppsAnywhere should ensure
that any launch request both has the affirmative consent of the local user -
preventing remote attacks - and refers to software from a trusted university -
preventing local attacks by an untrusted user, for example on a
university-owned machine in a computer lab.)

AppsAnywhere has described their changes as short-term fixes, and say they are
investigating longer-term improvements. In that context, their approach seems
reasonable.

## What do you need to do about this?

If you're on the IT team of a university using AppsAnywhere, the AppsAnywhere
team should have contacted you about an upgrade. Do this as soon as possible.

If you're an end user, check what version of AppsAnywhere you're running:

- On macOS, find `/Applications/Software2/AppsAnywhere.app` or `/Applications/AppsAnywhere/AppsAnywhere.app`, right click it, and choose "Get Info".
- On Windows, find `C:\Program Files\Software2\AppsAnywhere\AppsAnywhere.exe` or `C:\Program Files\AppsAnywhere\AppsAnywhere.exe`, and hover over it in the File Explorer.

If you're running a version before 1.6.1 or 2.0.1, try reinstalling
AppsAnywhere from your university's website; if you still don't have a new
enough version, I would recommend uninstalling AppsAnywhere until your
university releases an updated version.

## Timeline

- July 16, 2020: CVE-2023-41137 reported to University of St Andrews.
- July 21, 2020: University of St Andrews reports that they have been discussing
  the vulnerability with AppsAnywhere.
- November 2020: AppsAnywhere releases client 1.4.0 for macOS with an incomplete
  fix.
- August 4, 2023: Incomplete fix, and CVE-2023-41138, reported to University
  of St Andrews. Report acknowledged same day.
- August 9, 2023: Incomplete fix, and CVE-2023-41138, reported to AppsAnywhere,
  starting 90-day clock. Report acknoledged same day.
- September 22, 2023: CVE-2023-41138 fix complete; I'm provided with a beta. CVE-2023-41137 fix still in progress.
- October 9, 2023: Fixes complete, begin rolling out to universities.
- November 9, 2023: [Security advisory](https://docs.appsanywhere.com/appsanywhere/3.1/2023-11-security-advisory) published (two days past the 90-day window by mutual agreement).

Many thanks to the University of St Andrews Computer Security Incident Response Team and AppCheck for assistance in coordinating this response.
