---
layout: post
title: HAB telemetry system chosen
date: 2013-03-30 03:58
comments: false
categories: [hab, amateur radio]
tags: Electronics
---

As mentioned [before](/blog/2013/03/25/high-altitude-balloon-systems/) I'm planning on launching a high-altitude balloon later this year.  Most of the sensor technology is already finished; but we were stalled on the telemetry.  Mainly you must be able to find the payload in order to get the sensor data, the pictures, and the hardware.  

To reduce the complexity somewhat, I settled on using APRS for this first flight.  Later I might try some more interesting possibilities like an HF beacon that uses CW to broadcast its position.

For the APRS tracker, we're going to use the [Argent Data Systems](https://www.argentdata.com) tracker version [OpenTracker+ SMT](https://www.argentdata.com/catalog/product_info.php?cPath=22&products_id=64) which looks to be a nice compact solution for the HAB payload.  Equally compact is the VHF transmitter [SRB MX145](https://www.argentdata.com/catalog/product_info.php?cPath=25&products_id=134) which is capable of putting out between 350 and 500 mW.

While reading about the SRB MX145 in its [manual](http://rpc-electronics.com/datasheets/srb/srbmx145h.pdf) I noticed a comment about the modulation deviation:

> "Most trackers have high impedance outputs and the resulting signal level at the modulation input of the SRB-MX14 will not give sufficient deviation.  In addition they usually have significant harmonic content which will lead to an unwanted broad spectrum of the transmitted signal"  Therefore, they suggest the addition of an impedance converter combined with a low pass filter with a ~2.7kHz cutoff frequency."  

Page 7 of the manual provides a schematic for the filter/impedance converter circuit.

