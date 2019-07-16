# ezchk: Easy Computer-Network Configuration and Basic Functions Checking Tool

## Introduction

This tool is a first-step diagnostic data collection and printing script.

Due to specifics of the Windows OS and major target user base (of this project)
being Windows users, there are no plans for other OS support.

Frankly, I'll just have to make tailored tools for other operating systems in
that case.

## Data Collected (Windows)

* Motherboard name and model
* CPU manufacturer, name, data width ("bits"), No. (enabled/all) cores, threads
* Network interface (ipconfig, netsh, and PS Get-NetAdapterAdvancedProperty)
* Network function verification (DNS test against example.com)

## Potentially identifying data collected

* MAC Addresses

## TODO

* Automatic MAC address masking/camouflage tool (might need a "second pass"
  mechanism to go over the file and cover them up.)
* HTTP checker without cURL (our users are not tech-savvy).

