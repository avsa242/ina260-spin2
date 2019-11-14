# ina260-spin2 
--------------

This is a P2X8C4M64P/Propeller 2 driver object for the TI INA260 Precision Current and Power monitor IC

## Salient Features

* I2C connection at up to 400kHz
* Read manufacturer ID, die ID
* Read shunt current, bus voltage, calculated power
* Set operation mode (one-shot/triggered, continuous, power-down)
* Set conversion time for voltage and current measurements
* Set measurement averaging samples
* Set interrupt/alert source, threshold, active state (open-collector high/low), latching
* Read flags: conversion ready, power overflowed

## Requirements

* N/A

## Compiler Compatibility

* FastSpin (tested with 4.0.3-beta)

## Limitations

* Very early in development - may malfunction, or outright fail to build

## TODO

- [x] Implement methods for reading the three measurements
- [x] Implement methods for configuring the chip
- [x] Implement methods for setting interrupts/alerts
- [ ] Modify the alert threshold setting to accept natural values rather than a raw word
