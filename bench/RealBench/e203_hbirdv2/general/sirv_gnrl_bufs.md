# sirv_gnrl_bufs Module Documentation

## 1. Introduction

The `sirv_gnrl_bufs.v` file contains a collection of general buffer and synchronization modules used throughout the E203 processor design. These modules provide essential functionality for data flow control, clock domain crossing, and buffering operations. The file implements several key components:

- Pipeline stage buffer
- Asynchronous signal synchronizer
- Clock domain crossing (CDC) interface modules
- Bypass buffer
- General purpose FIFO

## 2. Interface

### 2.1 sirv_gnrl_pipe_stage

#### 2.1.1 Parameter Configuration


| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| CUT_READY      | 0             | Controls whether the ready signal is cut to avoid logic chains |
| DP             | 1             | Depth of the pipeline stage |
| DW             | 32            | Data width (in bits) |

#### 2.1.2 Signal Interface

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| i_vld | Input | 1 | Input valid signal |
| i_rdy | Output | 1 | Input ready signal |
| i_dat | Input | DW | Input data |
| o_vld | Output | 1 | Output valid signal |
| o_rdy | Input | 1 | Output ready signal |
| o_dat | Output | DW | Output data |
| clk | Input | 1 | Clock signal |
| rst_n | Input | 1 | Reset signal (active low) |

### 2.2 sirv_gnrl_sync

#### 2.2.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DP             | 2             | Depth of the synchronizer (number of flip-flops) |
| DW             | 32            | Data width (in bits) |

#### 2.2.2 Signal Interface

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| din_a | Input | DW | Asynchronous input data |
| dout | Output | DW | Synchronized output data |
| rst_n | Input | 1 | Reset signal (active low) |
| clk | Input | 1 | Destination clock domain |

### 2.3 sirv_gnrl_cdc_rx

#### 2.3.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |
| SYNC_DP        | 2             | Depth of the synchronizer for clock domain crossing |

#### 2.3.2 Signal Interface

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| i_vld_a | Input | 1 | Input valid signal (asynchronous) |
| i_rdy | Output | 1 | Input ready signal |
| i_dat | Input | DW | Input data |
| o_vld | Output | 1 | Output valid signal |
| o_rdy | Input | 1 | Output ready signal |
| o_dat | Output | DW | Output data |
| clk | Input | 1 | Clock signal |
| rst_n | Input | 1 | Reset signal (active low) |

### 2.4 sirv_gnrl_cdc_tx

#### 2.4.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |
| SYNC_DP        | 2             | Depth of the synchronizer for clock domain crossing |

#### 2.4.2 Signal Interface

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| i_vld | Input | 1 | Input valid signal |
| i_rdy | Output | 1 | Input ready signal |
| i_dat | Input | DW | Input data |
| o_vld | Output | 1 | Output valid signal (to async domain) |
| o_rdy_a | Input | 1 | Output ready signal (from async domain) |
| o_dat | Output | DW | Output data |
| clk | Input | 1 | Clock signal |
| rst_n | Input | 1 | Reset signal (active low) |

### 2.5 sirv_gnrl_bypbuf

#### 2.5.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DP             | 8             | Depth of the bypass buffer |
| DW             | 32            | Data width (in bits) |

#### 2.5.2 Signal Interface

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| i_vld | Input | 1 | Input valid signal |
| i_rdy | Output | 1 | Input ready signal |
| i_dat | Input | DW | Input data |
| o_vld | Output | 1 | Output valid signal |
| o_rdy | Input | 1 | Output ready signal |
| o_dat | Output | DW | Output data |
| clk | Input | 1 | Clock signal |
| rst_n | Input | 1 | Reset signal (active low) |

### 2.6 sirv_gnrl_fifo

#### 2.6.1 Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| CUT_READY      | 0             | Controls whether the ready signal is cut to avoid logic chains |
| MSKO           | 0             | Masks the output data with valid signal |
| DP             | 8             | Depth of the FIFO |
| DW             | 32            | Data width (in bits) |

#### 2.6.2 Signal Interface

| Signal Name | Direction | Width | Description |
|-------------|-----------|-------|-------------|
| i_vld | Input | 1 | Input valid signal |
| i_rdy | Output | 1 | Input ready signal |
| i_dat | Input | DW | Input data |
| o_vld | Output | 1 | Output valid signal |
| o_rdy | Input | 1 | Output ready signal |
| o_dat | Output | DW | Output data |
| clk | Input | 1 | Clock signal |
| rst_n | Input | 1 | Reset signal (active low) |
