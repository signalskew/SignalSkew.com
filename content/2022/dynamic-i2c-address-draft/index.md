---
title: "Dynamic I2c Address Draft"
date: 2022-06-17T07:49:48-06:00
draft: true
---

Requirements:
* Open source, therefore must not rely on preset globally-unique IDs (pre-programmed, DIP switches, solder jumpers, etc.)
* Must correctly handle multiple modules physically connecting simultaneously
* Discovery should also include physical position sensing realtive to controller and other modules

Notes:
* Can't use multimaster mode I2C because it doesn't satisfy any of the above 3 requirements as-is
  * https://electronics.stackexchange.com/questions/243465/dynamic-i%C2%B2c-address
* Simplest solution appears to be to include one addititional IO pin per side of tile

Flowchart:
* Module becomes physically connected to an unknown system. The module it is attached to is already binded
* Module powers on and wiggles its MISO pin to indicate "I'm here, and I'm ready for address assignment"
* Attached already-binded module receives signal
* Controller eventually polls binded module for status updates
* Binded module indicates it has an unbunded module attached
* Controller module commands binded module to wiggle MOSI pin to indicate incoming address
* New module sense pin wiggle and now knows any incoming address assignment will be meant for it
* Controller communicates on general broadcast address 0000whatever the new address
* New module takes on the new address and sends ACK back to controller
* Optional: New module wiggles pin to indicate successful address assignment to connected module
* Optional: Connected module senses pin wiggle and confirms with controller that thecorrect module got the address
* Optional: Any other modules can NACK if they believe the wrong module was assigned