# sd_clock_divider design specification

## Introduction

The `sd_clock_divider` module is a converter between the system clock and the clock required by the SD card-related modules.

The module perform the following actions.

- Divide the input clock signal based on the DIVIDER value and output it

## Interface

### IO Ports

| Direction | Width | name    | Description               |
| --------- | ----- | ------- | ------------------------- |
| input     | 1     | CLK     | CLK in                    |
| input     | 8     | DIVIDER | Division ratio            |
| input     | 1     | RST     | Asynchronous reset signal |
| output    | 1     | SD_CLK  | CLK out                   |

### IO Signal Description

The CLK is the clock signal before division, and SD_CLK is the clock signal after division. The RST signal is used to reset this module. The DIVIDER signal is used to control the division ratio.


## Operation

### Function Description

The Clock Divider takes the input clock signal (CLK) and produces an output clock signal (SD_CLK) with a frequency that is 1/(DIVIDER + 1) of the input frequency.


#### Clock and Reset

**Clock :`CLK`**

- Type: Synchronous
- Edge: Positive (rising edge)

**Reset:`RST`**

- Type: Asynchronous
- Active Level: High (`1`)
- Function: Immediately resets the SD_CLK to `0` regardless of the clock.

## Additional Constraints

| Name  | Description                                  | Effect                                                       |
| ----- | -------------------------------------------- | ------------------------------------------------------------ |
| SYN   | defined during synthesis                     |                                                              |
| SIM   | defined during simulation                    | Directly connect SD_CLK_O and SD_CLK                         |
| ACTEL | a specific backend version used in synthesis | Use SD_CLK_O as the output and SD_CLK as the input for CLKINT |
