# sirv_1cyc_sram_ctrl Module Documentation

## 1. Introduction

The `sirv_1cyc_sram_ctrl` module is a controller designed for single-cycle SRAM access requests. It manages read and write operations to SRAM and includes clock gating functionality to reduce power consumption. The module receives memory access requests through a command channel, controls SRAM operations, and returns read results via a response channel. This module is a key component in the processor's memory access path, suitable for scenarios requiring efficient memory access.

## 2. Interface

### 2.1. Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |
| MW             | 4             | Write mask width (in bits) |
| AW             | 32            | Address width (in bits) |
| AW_LSB         | 3             | Least significant bits of the address, used for byte-to-word addressing conversion |
| USR_W          | 3             | User data width (in bits), used to pass additional information between command and response channels |

### 2.2 Signal Interface

#### Control Signals

| Signal Name | Direction | Width | Description |
|--------|------|------|------|
| sram_ctrl_active | Output | 1 | Indicates that the SRAM controller is active |
| tcm_cgstop | Input | 1 | Clock gating stop signal from CSR, used for debugging purposes |
| test_mode | Input | 1 | Test mode signal |
| clk | Input | 1 | System clock |
| rst_n | Input | 1 | Reset signal (active low) |

#### Command Channel

| Signal Name | Direction | Width | Description |
|--------|------|------|------|
| uop_cmd_valid | Input | 1 | Command valid signal |
| uop_cmd_ready | Output | 1 | Command ready signal |
| uop_cmd_read | Input | 1 | Read/write operation selection (1 for read, 0 for write) |
| uop_cmd_addr | Input | AW | Access address |
| uop_cmd_wdata | Input | DW | Write data |
| uop_cmd_wmask | Input | MW | Write mask |
| uop_cmd_usr | Input | USR_W | User data (passed to response channel) |

#### Response Channel

| Signal Name | Direction | Width | Description |
|--------|------|------|------|
| uop_rsp_valid | Output | 1 | Response valid signal |
| uop_rsp_ready | Input | 1 | Response ready signal |
| uop_rsp_rdata | Output | DW | Read data |
| uop_rsp_usr | Output | USR_W | User data |

#### SRAM Interface

| Signal Name | Direction | Width | Description |
|--------|------|------|------|
| ram_cs | Output | 1 | SRAM chip select signal |
| ram_we | Output | 1 | SRAM write enable signal |
| ram_addr | Output | AW-AW_LSB | SRAM address |
| ram_wem | Output | MW | SRAM write mask |
| ram_din | Output | DW | SRAM write data |
| ram_dout | Input | DW | SRAM read data |
| clk_ram | Output | 1 | SRAM clock signal (after gating) |
