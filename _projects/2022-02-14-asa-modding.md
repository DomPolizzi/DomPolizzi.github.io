---
title: Install OPNSense and Linux on Cisco ASA
subtitle: Open Source your blackbox Cisco firewall
description: Free your Cisco ASA from closed-source firmware and put linux/bsd on it instead!
date: 2022-02-14 00:00:00
featured_image: /images/demo/demo-portrait.jpg
---

## Install OPNSense or Linux on Cisco ASA

Cisco is great network solution for most;however I don’t think its a 'one-size-fits-all' solution. Paywalls and Closed Source (Black Box) technologies will be the death of Privacy and Security. While Cisco has done a lot and is considered While I have already received hate for this and I understand why to a degree, this is meant to be a guide for those interested.

Note: this may seem complicated, but I assure you it is a cake walk in comparison to modding or jailbreaking an iPhone.

### Requirements:

1.	Patience, this is a base requirement in general 😉
2.  Live image of OPNSense flashed to a USB (or whatever OS you want to use)
*	Make sure you review base requirements for your Operating System of choice, I am using OPNSense [^2]
3.	Storage device, I used an SSD, you can use a HDD or a USB drive as your storage, this will go in your ASA and serve as its storage device
4.	IDC 16 PIN to VGA Adapter [^1]


## Get started:

1. Identify your Device (Cisco ASA Model):
* Open it up, read documents (that you can find) on your model Look into the Specs
* On the motherboard you should see a PINOUT for VGA (16 PIN IDC [^1]) This Pinout will be your entryway into the machine. 

2. Make your Bootable device:
* I used Rufus[^3] and the VGA OPNSense[^2] image. If you are here, I assume you already understand this topic so I will leave you to your own devices 😉 

3. Add your parts to the ASA
* I added an SSD to the front of it, 250GB should be plenty
* Add RAM if you want, I have 32GB already in mine
* Attach your Adapter[^1] and connect the VGA to a screen
* Attach a keyboard and your bootable device

## Show time:

1. Power on your device and enter the bios (Hitting F2 for me) 
* (boot screen took almost a minute to appear after power-on) 
2. In BIOS, Disable ROMMON
3. Switch the boot order; Make the USB the primary and HDD (boot device) as secondary.
4. Save changes and reboot
5. Enjoy the POWER! - Powering the ASA back on should find the bootable device. 
* Install your Operating system!


[^1]: [VGA Port HD15F Adapter to IDC16 from PC Cables](https://www.pccables.com/VGA_PORT_HD15F_PORT_To_IDC16.html).
[^2]: [OPNSense](https://opnsense.org/).
[^3]: [Rufus](https://rufus.ie).