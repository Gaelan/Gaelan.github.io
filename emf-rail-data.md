---
title: EMF Rail Data Talk
layout: default
---

At EMF 2024, I gave [a talk](https://www.emfcamp.org/schedule/2024/397-so-you-want-to-hack-on-rail-data-whats-out-there) about UK national rail open data; on this page, I've tried to collect links for people interested in any of the data sources I discussed. I've also collected links to other sites displaying the data in question, both as inspiration and because such sites are incredibly useful for debugging your own code using such data.

# SCHEDULE (Network Rail Schedule data)

[Access instructions on wiki](https://wiki.openraildata.com/index.php?title=SCHEDULE)

[CIF format documentation on wiki](https://wiki.openraildata.com/index.php?title=CIF_File_Format)

Notable sites displaying this data: [Open Train Times](https://www.opentraintimes.com), [Real Time Trains](https://www.realtimetrains.co.uk)

# VSTP

[Access instructions on wiki](https://wiki.openraildata.com/index.php?title=VSTP)

Notable sites displaying this data: [Open Train Times](https://www.opentraintimes.com), [Open Train Times](https://www.realtimetrains.co.uk)

# National Rail Timetable

[Access Instructions on Wiki](https://wiki.openraildata.com/index.php?title=DTD)

[Official documentation](https://data.atoc.org/sites/all/themes/atoc/files/RSPS5046.pdf)

Notable sites displaying this data: [BRfares](https://brfares.com)

# TRUST Train Movements

[Access Instructions on Wiki](https://wiki.openraildata.com/index.php?title=Train_Movements)

Notable sites displaying this data: [OpenTrainTimes](https://opentraintimes.com) ("Trains" tab), [RealTimeTrains](https://www.realtimetrains.co.uk) (uses a blend of TRUST and TD data for live running times)

# Train Describers

[Access instructions on Wiki](https://wiki.openraildata.com/index.php?title=TD)

Notable sites displaying this data: [OpenTrainTimes](https://www.opentraintimes.com/maps) ("Maps" tab), [Signal Maps](https://signalmaps.co.uk/), [Traksy](https://traksy.uk/)

# Darwin

Access instructions on wiki: [Push Port](https://wiki.openraildata.com/index.php?title=Darwin:Push_Port), [LDBWS](<https://wiki.openraildata.com/index.php?title=NRE_Darwin_Web_Service_(Staff)>)

The LDBWS comes in both "public" and "staff" versions, both of which are open data; the staff version provides more detail, so there's little reason to use the public version. Unfortunately, the sign up form for the staff version is currently broken; there's a manual replacement process, but it involves email and waiting a few weeks. If you're impatient, you could use the push port, the public version of LDBWS, or [Huxley](https://huxley2.azurewebsites.net), a third-party proxy which also provides a JSON interface over the original SOAP.

Notable sites displaying Darwin data: Every train company's website/app, Railboard (iOS)

# BPLAN

[Download](https://raildata.org.uk/dataProduct/P-03715cb3-22f2-48b6-94f6-bd88da9335f3/overview) (the Rail Data Marketplace has a sign-up process involving manual approval, but in my experienec they're fairly quick about it; the data itself is freely licensed)

[Documentation](https://wiki.openraildata.com/index.php?title=BPLAN_data_structure)

# ITPS Network Model

[Access Instructions](https://wiki.openraildata.com/index.php?title=Reference_Data#Train_Planning_Network_Model)

There's an XML schema, but unfortunately little documentation beyond this.

# Delay Attribution

[Download](https://raildata.org.uk/dataProduct/P-3fade1ab-0a85-4ac6-bc51-17c770350af3/overview) (see notes about Rail Data marketplace above)

# National Rail Knowledgebase (including incidents)

[Access instructions on wiki](https://wiki.openraildata.com//index.php?title=KnowledgeBase)

# Fares and Routeing Guide

[Access instructions on wiki](https://wiki.openraildata.com/index.php?title=DTD)

Official docus: [Fares](https://data.atoc.org/sites/all/themes/atoc/files/RSPS5045.pdf), [Routeing Guide](https://www.rspaccreditation.org/downloadPublic.php?DOCUMENT=RSPS5047+P-02-02+National+Routeing+Guide+Data+Feed+Specification.pdf&ID=1303)

See also [here](https://data.atoc.org/routeing-guide) for more general docs on how the routeing guide works

Notable sites: https://brfares.com for fares data; https://data.atoc.org/routeing-guide provides PDF versions of the routeing guide data but I'm not aware of anything else public displaying the data

# Origin-Destination Matrix

[2022-23 ODM](https://raildata.org.uk/dataProduct/P-a839de9f-eafa-495e-92e3-ff23a33ad876/overview)

Previous years' ODMs are also available on the same site.
