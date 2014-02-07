---
layout: post
title: High-altitude balloon systems
date: 2013-03-25 09:15
comments: false
categories: [hab, Rpi]
tags: Rpi, Electronics
---
I've been planning a high-altitude balloon launch for a long time.  Initially I was planning to launch it with an AVR-based flight computer.  But when the Raspberry Pi came out I decided to switch my development efforts, like [this guy](http://www.projectblacksky.com/index.html) and [this guy](http://www.daveakerman.com/?p=592).  I spend my days mostly developing at a fairly high level of abstraction so I feel most confident working at that level.  Being able to program the RPi in Python is huge for me.

<img src="/images/2013_03_25_hab_plans/hab_plan.png" alt="Figure 1" style="float: left; padding-right: 10px;">

The plans for the payload are still in evolution, but here's what I have so far:

- [Raspberry Pi](http://www.raspberrypi.org) will be the main flight computer
- We will get barometric pressure (and therefore altitude) data from a [BMP085](https://www.adafruit.com/products/391)
- 3-axis acceleration data will come from an [ADXL335](http://www.adafruit.com/products/163) analog accelerometer connected to an [ATtiny261](http://www.atmel.com/devices/attiny261.aspx) chip which will connect to the RPi via the I2C bus as described [here](/blog/2013/03/24/adc-for-raspberry-pi/).  (The diagram shows an 861.  I think the memory footprint needed is much lower than that.)
- Humidity data from inside the payload and outside will come from two analog humidity monitors also connected to the AVR ADC-I2C bridge.
- We will get real-time clock data from a [DS1307](https://www.adafruit.com/products/264) on the I2C bus.
- Imagery will come from a [Canon PowerShot G6](http://www.dpreview.com/reviews/canong6) connected to the RPi by USB.  We'll use gphoto to capture images.
- Flight data will be dumped to a USB-connected giveaway flash drive that I got from a conference.

There are still design decisions to be made, mainly how to command a cutdown, and how we'll transmit the telemetry data.  As an amateur radio license holder (KD0RXD), I have a number of options but I need to sort through them systematically.

Questions?  Comments?  I'm on Twitter `@NSBum`.