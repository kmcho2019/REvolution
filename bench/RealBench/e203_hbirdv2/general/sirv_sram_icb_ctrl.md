# sirv_sram_icb_ctrl Design Specification

## Introduction

The `sirv_sram_icb_ctrl` module serves as a controller for handling ICB (Internal Configurable Bus) access requests to SRAM memory. It provides an interface between the ICB bus protocol and the SRAM memory, managing command buffering and response generation to optimize performance and reduce pressure on the ready signal.

## Interface

### Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits), supports only 32 or 64 bits |
| MW             | 4             | Write mask width (in bits) |
| AW             | 32            | Address width (in bits) |
| AW_LSB         | 3             | Least significant bits of the address, used for byte-to-word addressing conversion |
| USR_W          | 3             | User-defined signal width |

### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| sram_ctrl_active | Output | 1 | Active status indicator for clock gating control |
| tcm_cgstop | Input | 1 | Clock gating stop signal from CSR (for debugging) |
| i_icb_cmd_valid | Input | 1 | ICB command valid signal |
| i_icb_cmd_ready | Output | 1 | ICB command ready signal |
| i_icb_cmd_read | Input | 1 | Read/write indicator (1 = read) |
| i_icb_cmd_addr | Input | AW | Command address |
| i_icb_cmd_wdata | Input | DW | Write data |
| i_icb_cmd_wmask | Input | MW | Write mask |
| i_icb_cmd_usr | Input | USR_W | User-defined command signals |
| i_icb_rsp_valid | Output | 1 | ICB response valid signal |
| i_icb_rsp_ready | Input | 1 | ICB response ready signal |
| i_icb_rsp_rdata | Output | DW | Read data response |
| i_icb_rsp_usr | Output | USR_W | User-defined response signals |
| ram_cs | Output | 1 | RAM chip select |
| ram_we | Output | 1 | RAM write enable |
| ram_addr | Output | AW-AW_LSB | RAM address |
| ram_wem | Output | MW | RAM write enable mask |
| ram_din | Output | DW | RAM data input |
| ram_dout | Input | DW | RAM data output |
| clk_ram | Output | 1 | RAM clock signal |
| test_mode | Input | 1 | Test mode enable |
| clk | Input | 1 | System clock |
| rst_n | Input | 1 | Reset signal (active low) |
