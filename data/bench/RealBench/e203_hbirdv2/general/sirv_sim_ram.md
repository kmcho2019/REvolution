# sirv_sim_ram Design Specification

## Introduction

The `sirv_sim_ram` module provides a behavioral simulation model of Static Random Access Memory (SRAM). It is designed for use in simulation environments to model memory components with configurable width, depth, and byte-enable capabilities.

## Interface

### Parameter Configuration

| Parameter Name   | Default Value | Description |
|------------------|---------------|-------------|
| DP               | 512           | Depth of the RAM (number of entries) |
| FORCE_X2ZERO     | 0             | Forces uninitialized memory to zero during simulation |
| DW               | 32            | Data width (in bits) |
| MW               | 4             | Write mask width (in bits) |
| AW               | 32            | Address width (in bits) |

### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| clk | Input | 1 | Clock signal |
| din | Input | DW | Data input (write data) |
| addr | Input | AW | Memory address |
| cs | Input | 1 | Chip select (memory enable) |
| we | Input | 1 | Write enable signal |
| wem | Input | MW | Write enable mask (byte-enable) |
| dout | Output | DW | Data output (read data) |
