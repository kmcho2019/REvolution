# sd_crc_16 design specification

## Introduction

This document provides a detailed description of the CRC Generation Unit implemented using a Linear Feedback Shift Register (LFSR) in Verilog. The `sd_crc_16` module computes a 16-bit CRC value based on the input data bits.

## Module Overview


### Interface

| Direction | Name   | Width | Description                        |
|-----------|--------|-------|------------------------------------|
| input     | BITVAL | 1     | Next input bit                     |
| input     | Enable | 1     | Enables CRC updating               |
| input     | CLK    | 1     | Current bit valid (Clock)         |
| input     | RST    | 1     | Initializes CRC value to zero      |
| output    | CRC    | 16    | Current output CRC value           |



## Clock and Reset

**Clock :`CLK`**

- Type: Synchronous
- Edge: Positive (rising edge)


**Reset:`RST`**

- Type: Asynchronous
- Active Level: High (`1`)



## Function and Logic

### Combinational Logic

- **`inv` Calculation**: `inv` is computed as the XOR of the current input bit (BITVAL) and the most significant bit (MSB) of the CRC.

### Sequential Logic

On each rising edge of the clock or when the reset signal is high, the module performs the following operations:

1. **Reset Handling**: If the reset signal (RST) is high, the CRC value is immediately set to zero.
2. **CRC Update**: If the enable signal (Enable) is high, the module performs bit-shifting and updating operations for the CRC:
   - Each bit of the CRC is shifted to the left.
   - The specific bits of the CRC are updated as follows:
     - CRC[12] is updated to the result of the XOR between CRC[11] and `inv`.
     - CRC[5] is updated to the result of the XOR between CRC[4] and `inv`.
   - CRC[0] (the least significant bit) is set directly to `inv`.
