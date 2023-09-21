---
title: A Traveller’s Guide To What Apps The Local Public Transport Nerds Use
layout: default
---

When I'm travelling on the train network of my home(?) country of Britain, I have a giant pile of unofficial apps and websites I use to understand the status of my trains---within a minute or so after my train pulls to a stop, I'll be looking at the signal diagram and know that we're stuck behind the late-running train to Plymouth.

Outside Britain, though, my level of literacy falls to "I'm on a train, I think." Some of this is down to Britain's strong ecosystem of publicly available transport data; but much of the problem is that I don't know where to look! As such, I'd like to start gathering a list of all those unofficial tools, for the benefit of travellers who find themselves outside the reach of their familiar apps.

I've started this list off with what I know (some tools I've used, some I'm aware of that seem good on a first glance); if you have additions or corrections, please send them to me by [email](gbs+trainapps@canishe.com) or [on the Fediverse](https://cathode.church/@Gaelan)!

This page is licensed under [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.en).

# Worldwide Apps

**[Öffi](https://oeffi.schildbach.de)** is an Android app providing public transport data in many areas, primarily Europe but also North America and possible Australia. I'm told it works well in Germany and Austria, less so in the UK; I don't have an Android phone so haven't tested it myself.

# Europe

## Pan-European Apps

[Detutsche Bahn](https://bahn.de/en)'s joruney planner has timetable data for more or less every European country, and will happily offer journeys from, say, London to Istanbul. It won't actually be able to sell tickets for such a journey, mind, but still hugely useful for getting a sense of the route.

[Zugfinder](https://www.zugfinder.net/) purports to offer status information for intercity trains in eight European countries. I've found it to be rather janky, but it's better than nothing.

## Germany

I'm told **[Bahn Experte](https://bahn.expert)** is good. No English UI (that I can find), but you can probably get the gist.

## Great Britain

### Mainline Trains

The British mainline "National Rail" network encompases all domestic intercity and suburban rail, including Liverpool's Merseyrail and London's Overground and Elizabeth Line. Some non-National-Rail services also share mainline track for part of their journeys, so might appear in these tools, but will only show useful data for the portions on mainline track; data for other parts will be missing or wrong. Such services include Eurostar (the entire portion within the UK), London Underground (outer reaches of serveral lines), and Sheffield's Tram Trains.

Useful things to know about when referring to these resources:

- While Britain has no public train numbers like the rest of Europe (announcements instead refer to "the 10:23 service to Floopington"), trains are internally referred to using "headcodes", identifers like 1A35. Headcodes aren't unique nationwide, but are generally "unique enough" within a given area.
- Physical rolling stock is identified to using "TOPS codes" such as 43134 or 800321; the first two digits of a five-digit TOPS code, or the first three digits of a six-digit TOPS code, refer to the model of train (a [class 43](<https://en.wikipedia.org/wiki/British_Rail_Class_43_(HST)>) and a [class 800](https://en.wikipedia.org/wiki/British_Rail_Class_800), respectively).

**[Railboard](https://www.railboard.com)** (iOS-only, unfortunately) is a client for Darwin, the passenger-facing system used to display train times on departure boards and the like. It's my go-to for checking trains while travelling, unless I need something more specific provided by one of the below apps.

**[RealTimeTrains](https://www.realtimetrains.co.uk)** provides access to, well, real time train statuses for any train on the British mainline train network, including scheduled and actual times for all stations (including ones passed at speed) - great for figuring out where you are, or what train just passed you. In many cases, it is also able to display the TOPS code (and thus model) of the train allocated to a given service.

**[OpenTrainTimes](https://www.opentraintimes.com/maps)** provides real-time signalling maps of much of the British mainline network. Hugely useful for figuring out why your train is stopped, and for figuring out which train will arrive first when you're trying to make a tight connection. Bit tricky to read, but the [help page](https://www.opentraintimes.com/maps/help) is useful. OpenTrainTimes also provides status information similar to RealTimeTrains, but I find RealTimeTrains nicer to use for this.

Note that Railboard uses the passenger-facing Darwin system, while RTT and OTT use internal data from Network Rail, the infrastructure operator. This means they sometimes provide different information; for example, sometimes cancellations appear on one before the other. It's worth keeping an eye on both when things get hairy.

**[BRtimes](https://www.brtimes.com) and [BRfares](https://www.brfares.com)** are frontends to the National Rail timetable and fare data, respectively. These are my favorite tools for getting a rough sense of what a journey would look like, but note that neither of them have access to real-time data. BRtimes won't tell you about on-the-day cancellations or delays, and BRfares can only give you the theoretical price levels for a ticket, not what the price will be for advance tickets for a given train on a specific day.

Any train company will sell you tickets for any mainline train at the same prices, but **[TrainSplit](https://trainsplit.com)** is often able to find cheaper prices by using a combination of tickets. It also has good search tools that can be used to massage it into booking you an unusual route. Railboard (mentioned above) also sells tickets via TrainSplit (and thus gets the same prices), but I usually prefer the website unless I'm booking on the go.

In Scotland, ScotRail uses a horrible format for digital tickets that TrainSplit can't issue. Usually I buy from TrainSplit anyway (and pick up from a ticket machine), but if you're rushing for a train you may prefer the **[ScotRail app](https://www.scotrail.co.uk/smart-tickets/mtickets)**, which can issue digital tickets.

While seat reservations are never required (except on sleepers), they're nice to have; if you ever find yourself with a ticket but no seat reservation (for example, if you have a flexible ticket, or you're travelling on a later train due to a missed connection), you can get one for any train operator on **[GWR's website](https://www.gwr.com)**, under My account > View bookings > Make a seat/bike reservation.

### Local transport

**[bustimes.org](https://bustimes.org)** provides timetable data, and real-time maps, for buses across Britain and Ireland. It also includes various tram and metro services, including the London Underground, though intertube provides more detail there.

**[intertube](https://intertube.eta.st)** provides real-time running data for the London Underground and Elizabeth Line.

## Ireland

**[bustimes.org](https://bustimes.org)** provides timetable data, and real-time maps, for buses across Britain and Ireland. It also appears to display Republic of Ireland train timetables (including Dublin DART and the Enterpise to Belfast), but not real-time status information.

## Netherlands

### Mainline trains

**[Treinposities](https://treinposities.nl)** provides train status, departure boards, rolling stock used, and a nationwide map of train locations. There's an English version (click the flag in the navbar).

### Local transport

**[Busposities](http://www.busposities.nl)** provides a live map of bus/tram/metro/etc vehicles (but no future timetables, as far as I can see).

# North America

## Intercity trains

**[Intercity Rail Map](https://asm.transitdocs.com)** provides a good indication of the location and status of all Amtrak/Via trains.

## Local Transit

**[Pantograph](https://www.pantographapp.com)** provides a realtime status map of buses, metros, ferries, etc in 14 US/Canadian regions.

# Oceania

**[AnyTrip](https://anytrip.com.au/)** provides vehicle position tracking across much of Australia and Aotearoa New Zealand. Originally based in New South Wales but seemingly decent coverage elsewhere too.
