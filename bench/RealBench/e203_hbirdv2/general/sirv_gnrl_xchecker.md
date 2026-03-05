# sirv_gnrl_xchecker Design Specification

## Introduction

The `sirv_gnrl_xchecker` module is a verification utility designed to detect unknown ('X') values in signals during simulation. It uses SystemVerilog assertions to check signal integrity, helping identify potential issues in the design that could lead to indeterminate behavior.

## Interface

### Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width of the input signal to be checked for 'X' values |

### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_dat | Input | DW | The input data signal to be checked for 'X' values |
| clk | Input | 1 | Clock signal to synchronize the assertion checking |
