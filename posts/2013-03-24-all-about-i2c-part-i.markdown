---
layout: post
title: All about I2C: Part I
date: 2013-03-24 17:19
comments: false
categories: [tutorial, mcu, i2c]
tags: Electronics
---
### What the hell is really going on in I2C anyway? ###

If you're used to working at the "Arduino-level" of knowledge, then you know the I2C is a two-wire peripheral interface, etc. etc.  If you already know that level, but want to know more about how it works at the physical bit layer, read on.  This tutorial is meant to help you understand what's going on without the higher level of abstraction that libraries like `Wire.h` exposes. 

For the purposes of this tutorial, we're going to temporarily ignore the situation where there are multiple masters on the bus.  Instead, we'll assume a single master and one or more slaves.  This allows us to pose the following question:

#### Who drives the clock - master, slave, or both? ####
In our typical simplified case, it's the **master** that drives the clock.

#### Since I2C is described as a two-wire interface, what are the _"two wires"_?
There are indeed only two signals:  **SDA** or serial data and the clock **SCL** or serial clock.  The narrower bus is convenient but it requires considerable orchestration between slaves and master.  The rest of this tutorial is all about this coordination.

#### Why are pullup resistors generally required on the I2C lines? ####
This is because when any device on the bus pulls the line low, the line must be low at each of the drops.  Similarly, a high logic level condition on the bus requires that all devices stop drinving it.  

As a brief, but important, aside, the SDA and SCL pins must be implemented as open collector outputs.  ![Open collector schema](http://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/OpencollectorV3.png/800px-OpencollectorV3.png)

When the the external side of the output transistor, the collector, is connected to a pullup resistor, the pin is at a logic high when the transistor is turned off.  When the transistor is turned on, the output voltage falls to a low logic level.  This is why pullup resistors are use on these lines.

#### Starting and stopping a transfer ####

Since we're talking about a bus, this is about data transfer.  Since for practical reasons, the data transferred across the bus is finite, there must be a **start** and **stop** condition to bookend the interaction.  Unsurprisingly, these are the `START` and `STOP` conditions. 

The `START` condition is defined when the SCL line is high and the SDA line transitions from high to low.  There is no other moment in the protocol where this is true.  Normally state transitions of the SDA line occur only when the SCL line is low.

Similarly, there is a `STOP` condition that does not occur otherwise during data transfer.  This happens when the SDA transitions from low to high while the SCL is high.  

#### Data transfer on the bus ####

Every unit of data that is sent on the bus is 8 bits wide.  The master is responsible for initiating and stopping the data transfer by asserting the conditions described above.  At the beginning of a transfer, the master lower SDA while SCL is high, creating a `START` condition on the bus.  Thereafter, it sends transfers 7 bits of slave address on SDA clocked via SCL.  The last (least significant) bit in the stream is the read/write bit, where read is a logic 1 and write is a logic 0.  

Up until now, all of the work is being done by the master.  Now the master expects a response.  In this case, the master lowers SCL a ninth and final time.  This is when the slave that responds to the transferred address must respond by lowering SDA.  This is an `ACK`.

Take a look at Figure 1 to visualize a typical write sequence from master to slave:

{% imgcap left /images/i2c-master-write.001.png Figure 1 %}

#### Reading data from the slave ####

When the master device wishes to read data from a slave, it follows the same general protocol as that for a write.  First it generates a start condition followed by seven bits of address data, the followed by a read bit.  This comprises a 9 bit preamble that address the device of interest.  Then, the slave device sends an `ACK` to acknowledge the receipt of the address and read/write designator.  This is immediately followed by 8 bits of data.  So far it's almost just like the situation with the master-to-slave write described above.  But now, it's the master, not the slave that most `ACK` the data.  Each 8 bit byte of data transfered from slave to master is punctuated by an `ACK` from the master.  That is _each byte until the last one_.  When the master needs no more data, it sends a `NACK` which is the equivalent of the telling the slave device to "shut up."  We could visualize it like Figure 2.

<img src="/images/i2c-master-read.001.png" alt="Figure 2" style="float: left; padding-right: 10px;">

#### How can I possibly diagnose problems on the bus? ####

I started this tutorial by describing a goal of taking your knowledge about the I2C/TWI bus beyond the `Wire.h` level.  But with that comes the usual challenges presented by getting closer to silicon.  My preferred approach to dealing with this is the logic analyzer.  I use the [Intronix Logicport analyzer](http://www.pctestinstruments.com)  I can't say enough good things about this device although it *is* expensive.  A less expensive alternative for listening to the I2C (and other) buses is the [Bus Pirate](http://dangerousprototypes.com/docs/Bus_Pirate).  I have no direct experience with the Bus Pirate - but I understand the principle and it seems sound.

To give you a sample of what bus analysis looks like in the context of what we've been talking about, take a look at Figure 3:

<img src="/images/i2c_tutorial_1_trace.png" alt="Figure 3" style="float: left; padding-right: 10px;">

At a glance, you can see exactly what is happening on the bus.  For example, you can see the waveforms that mark the `START` condition.  _(You do remember what defines a `START` condition right?  No?  It's when the master drives SDA low while SCL is high.)_  Then we see 

That's for part I.  Hope that helps take one layer of mystery out I2C.