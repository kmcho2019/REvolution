# sirv_gnrl_ram Design Specification

## Introduction

The `sirv_gnrl_ram` module is a general-purpose RAM wrapper that serves as the top-level RAM module in the system. It provides a configurable memory implementation that can adapt to different target environments (FPGA, ASIC, or simulation) by conditionally instantiating the appropriate underlying RAM model.

## Interface

### Parameter Configuration

| Parameter Name   | Default Value | Description |
|------------------|---------------|-------------|
| DP               | 32            | Depth of the RAM (number of entries) |
| DW               | 32            | Data width (in bits) |
| FORCE_X2ZERO     | 1             | Forces uninitialized memory to zero |
| MW               | 4             | Write mask width (in bits) |
| AW               | 15            | Address width (in bits) |

### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| sd | Input | 1 | Power shutdown control signal |
| ds | Input | 1 | Deep sleep mode enable signal |
| ls | Input | 1 | Light sleep mode enable signal |
| rst_n | Input | 1 | Active-low reset signal |
| clk | Input | 1 | Clock signal |
| cs | Input | 1 | Chip select (enable) signal |
| we | Input | 1 | Write enable signal |
| addr | Input | AW | Memory address |
| din | Input | DW | Data input (write data) |
| wem | Input | MW | Write enable mask (byte-enable) |
| dout | Output | DW | Data output (read data) |
