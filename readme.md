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

This policy was chosen due to our original intended use: for tech support within
the same organization by a local administrator.

### General data collected (Windows)

* Motherboard name and model
* CPU manufacturer, name, data width ("bits"), No. (enabled/all) cores, threads
* Network interface (ipconfig, netsh, and PS Get-NetAdapterAdvancedProperty)
* Summary of configuration files (etc\hosts)
* Network function verification (DNS test against example.com)

### Potentially identifying data collected

* Anonymized MAC Addresses. We hide most of the meaningful part of your MAC
  addresses, but retain: the first half (manufacturer identifier) and the last
  two letters (for identification purposes on our side, if needed).
* Access point you are currently connected to. This directly has to do with
  infrastructure diagnosis.
* Your domain name (may reveal your workplace/organization). We need this to
  see if there are no faulty configuration files.

By running this tool, you consent that the log file generated will contain this
information. You however control who you send it to.

### What is not collected

* Unique IDs like IAID/DUID (for network configuration) and GUID (network
  interface identifier) are completely hidden.
* Your host name is completely hidden.

## How to use:

1. Double click to run the batch file.
2. Send the generated log file (log.txt) to your tech support.

## TODO

* More comprehensive and intelligent interface identity anonymization, e.g.
  00:11:22:33:44:55 for Wi-Fi becomes 00:11:22:XX:WI:01 and 00:22:44:66:88:AA
  for Ethernet becomes 00:22:44:XX:ET:02. If possible.
