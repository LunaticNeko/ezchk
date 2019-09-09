# ezchk: Easy Computer-Network Configuration and Basic Functions Checking Tool

## Introduction

This tool is a first-step diagnostic data collection and printing script.

Due to specifics of the Windows OS and major target user base (of this project)
being Windows users, there are no plans for other OS support.

Frankly, I'll just have to make tailored tools for other operating systems in
that case.

## Data Collection

ezchk collects some *GENERAL* information of *YOUR* computer and current network
availability status. However, the *ACCESS POINT INFORMATION* of your network
*ARE COLLECTED IN FULL*.

This means you *SHOULD NOT* send this to anyone outside of your household,
company, or school.

This policy was chosen due to original intended use: for tech support within
the same organization by a local administrator.

### General data collected (Windows)

* Motherboard name and model
* CPU manufacturer, name, data width ("bits"), No. (enabled/all) cores, threads
* Network interface (ipconfig, netsh, and PS Get-NetAdapterAdvancedProperty)
* Operating system version and latest patches
* Summary of configuration files (etc\hosts)
* Network function verification (DNS test against example.com)

### Potentially identifying data collected

* Anonymized MAC Addresses. We hide most of the meaningful part of your MAC
  addresses, but retain: the first half (manufacturer identifier) and the last
  two letters (for identification purposes on our side, if needed). See below
  for even more details.
* Access point you are currently connected to. This directly has to do with
  infrastructure diagnosis. Also see below.
* Your domain name (may reveal your workplace/organization). We need this to
  see if there are no faulty configuration files.
* Custom routing information or configuration that the software may not properly
  recognize and remove.

By running this tool, you consent that the log file generated will contain this
information. You however control who you send it to, and you are of course free
to edit the log file before submitting it to your tech support.

### What is not collected

* Unique IDs like IAID/DUID (for network configuration) and GUID (network
  interface identifier) in some designated fields are completely hidden.
* Your host name in designated fields are completely hidden.

### What's all of this about MAC address?

Some of your hardware identifiers (MAC Addresses) are partially hidden. We
currently mask addresses like 00:11:22:33:44:55 to 00:11:22:XX:XX:55. The
first half is your Organizationally Unique Identifier (OUI), a.k.a.
Manufacturer ID, which helps your tech support identify the brand of your
network interfaces or mobile device. The last number pair in the second half
is kept to help your tech support identify different network interfaces (e.g.
Wi-Fi and cabled-LAN) belonging to the same brand on your computer, or various
virtual network interfaces introduced by software and utilities.

As described earlier, the MAC address of your "connected-to" access point is NOT
hidden. This is to help your tech support identify weak points in the network.
Therefore, you should not submit the log file to people outside your company or
school.

## How to use:

1. Download the "batch" file called "ezchk-win.bat" to your computer.
2. Double click to run the batch file.
3. Send the generated log file (ezchk-log.txt) to your tech support.

The log file should be in the same place as the batch file. It should be
somewhere in C:\Users\\(YourName)\\

## FAQ

1. Why was this made? We want to address problems of local IT users who might not
   be knowledgeable in CLI operations. This tool is expected to reduce the number
   of IT center visits and stuff arising from "user can't ipconfig and come
   crying at our helpdesks."
2. Why Windows only? Our organization runs 99% on Windows. The rest 1% who use
   Mac or Linux can potentially solve their own problems or at least run
   ifconfig and cry through the mail instead.
3. ezchk? Really? Yep. It's that E-Z. G-G-E-Z. If you're asking about the naming
   convention: I'm not a creative person.
4. No ping or nslookup 8.8.8.8 or other DNS? Our org blocks them. It's useless
   for us, right now, so I'm not focusing on that.
5. Why run PowerShell from BAT instead of just using a PS1 script file? This is
   because BAT files can be run without permission requirements even if they do
   invoke PowerShell. Also, they are tried-and-true to be double-clickable,
   which is important for people unfamiliar with file property configuration.
   PowerShell is used so we can obtain much more diagnostic data that would take
   multiple steps with BAT and CMD instructions, and also used to "standardize"
   the output, freeing it from OS influences such as language configuration.

## About Us

Lead Author: Chawanat Nakasan

Email (current): <firstname>@staff.kanazawa-u.ac.jp

Proudly Programmed in Kanazawa!

Copyright is retained by the Author and license is granted through the MIT
License. See license file for details.

