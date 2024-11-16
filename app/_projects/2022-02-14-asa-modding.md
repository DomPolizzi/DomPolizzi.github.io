---
title: Install OPNSense and Linux on Cisco ASA
subtitle: Open Source your blackbox Cisco firewall
description: Free your Cisco ASA from closed-source firmware and put linux/bsd on it instead!
date: 2022-02-14 00:00:00
featured_image: /images/site-assets/tux.jpg
---

## Install OPNSense or Linux on Cisco ASA

Cisco is a great network solution for most, but I don't think it is a ''one-size-fits-all'' solution as most would believe. 

Pay-Walls, Closed Source, and Black Box technologies will be the death of Privacy and Security. While Cisco has done a lot and is considered the "gold standard," it isn't ideal for those who care for privacy due to its relation with IBM. 

During my search for this deemed 'impossible' task, I have found a lot of unusual hate surrounding this topic. I don't understand why, but I hope to save others from the hive-minded's trouble towards questioning and wasting any more precious time.

Some of you reading this may think I am an absurd lunatic, and to a degree, that is totally valid; however, that is beside the point!
This article's "point" is to help the curious and interested in tinkering, learning, or even furthering the community and the technologies available. In my opinion, this could be the beginning of what could revolutionize the way admins think of "dated" devices. This is a matter of unlocking doorways and reintroducing the mindset of "what can one make this device do" rather than just using it as is.


This "impossible" task may seem complicated, but I assure you it is a cakewalk! Once opened up, it's as easy as 1-2-3! Well easier than modding phones ;)

### Requirements:

1. Patience, this is a base requirement in general. 😉
2. A live image of OPNSense flashed to a USB (or whatever OS you want to use)
   *  Make sure you review base requirements for your Operating System of choice, I am using OPNSense. [^2]
3. Storage device, I used an SSD; you can use an HDD or a USB drive as your storage. This will go in your ASA and serve as its storage device.
4. IDC 16 PIN to VGA Adapter ( [$6 USD from PCCABLES.com](https://www.pccables.com/VGA_PORT_HD15F_PORT_To_IDC16.html) ) [^1] 


### Get started:

1. Identify your Device (Cisco ASA Model):
   * Open the ASA up, read documents (that you can find) on your model, look into the specifcations
   * On the motherboard, you should see a PINOUT for VGA (16 PIN IDC [^1]). This PINOUT will be your entryway into the machine and allow you to bypass ROMMON. 
<div class="gallery" data-columns="1">
     * <img src="/images/img/asa-vga.jpg">
</div>

2. Make your Bootable device:
   * I used Rufus[^3] and the VGA OPNSense[^2] image. If you are here, I assume you already understand this topic, so I will leave you to your own devices 😉 

3. Add your parts to the CISCO ASA
   * I added an SSD to the front of it, 250GB should be more than enough
   * Add RAM if you want; I have 32GB already in mine but it depends on the specs/limits of your device
   * Attach your Adapter[^1] and connect the VGA to a screen
* Attach a keyboard and your bootable device

### Show time:

1. Power on your device and enter the bios (Hitting F2 for me) 
   *  (boot screen took almost a minute to appear after power-on)
2. In BIOS, Disable ROMMON.
3. Switch the boot order; Make the USB the primary and HDD (boot device) as secondary.
4. Save changes and reboot.
5. Enjoy the POWER! - Powering the ASA back on should find the bootable device. 
   *  Install your Operating system! BONUS Points if you can run DOOM on it . . .


### Conclusion:

As of writing this, I have OPNSense running on my CISCO ASA-5555X! These modifications have turned this once scrapped device into a fantastic multi-purpose machine for my home network, free of the subscriptions and closed source limitations. The best part is I have control over the device the way I want to have it.

I hope this helps; feel free to email me or message me on Linkedin;  I love to collaborate and conversate! Let me know your experiences, I have seen EXSXi running on these mini powerhouses, which is brilliant!

 All the best,
 Dominic
#### Links:

[^1]: [VGA Port HD15F Adapter to IDC16 from PC Cables](https://www.pccables.com/VGA_PORT_HD15F_PORT_To_IDC16.html).
[^2]: [OPNSense](https://opnsense.org/).
[^3]: [Rufus](https://rufus.ie).