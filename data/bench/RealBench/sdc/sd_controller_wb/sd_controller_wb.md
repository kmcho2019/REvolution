# sd_controller_wb design specification

The `sd_controller_wb` module are the wishbone slave interface, it manage the reading and writing to the configuration registers. 


## Introduction

WISHBONE is a simple, open-source hardware bus architecture used in digital circuits. It connects different components like processors and memory, allowing them to communicate. This interface should adhere to wishbone specification, detailed in WISHBONE SoC Architecture Specification, Revision B.3.

The host uses this module to assign values to configuration registers to configure the SD card and reads some register values to obtain the SD card's operational status.

### Module Function

The sd_controller_wb module perform two main tasks:

- Assign values to the configuration registers according to the host's settings.
- Return the value of the configuration register specified by the host.

## Interface

### IO Ports

| Port Type |     Width     | Name                         | Description                             |
| :-------: | :-----------: | :--------------------------- | :-------------------------------------- |
|   Input   |       1       | wb_clk_i                     | Slave WISHBONE Clock Input              |
|   Input   |       1       | wb_rst_i                     | Slave WISHBONE Reset Input              |
|   Input   |      32       | wb_dat_i                     | Slave WISHBONE Data Inputs              |
|  Output   |      32       | wb_dat_o                     | Slave WISHBONE Data Outputs             |
|   Input   |       8       | wb_adr_i                     | Slave WISHBONE Address Input            |
|   Input   |       4       | wb_sel_i                     | Slave WISHBONE Select Input             |
|   Input   |       1       | wb_we_i                      | Slave WISHBONE Write Enable             |
|   Input   |       1       | wb_cyc_i                     | Slave WISHBONE Cycle                    |
|   Input   |       1       | wb_stb_i                     | Slave WISHBONE Strobe                   |
|  Output   |       1       | wb_ack_o                     | Slave WISHBONE Acknowledge              |
|  Output   |       1       | we_m_tx_bd                   | Write enable TIx BD                     |
|  Output   |       1       | we_m_rx_bd                   | Write enable Rx BD                      |
|  Output   |       1       | new_cmd                      | New command indication signal           |
|  Output   |       1       | we_ack                       | Ack on cmd access request               |
|  Output   |       1       | int_ack                      | Internal Delayed Acknowledge            |
|  Output   |       1       | cmd_int_busy                 | Cmd busy by data module                 |
|  Output   |       1       | int_busy                     | Command Busy by data module             |
|   Input   |       1       | write_req_s                  | Cmd access request                      |
|   Input   |      16       | cmd_set_s                    | Command setting input from data master  |
|   Input   |      32       | cmd_arg_s                    | Command argument input from data master |
|  Output   |      32       | argument_reg                 | Command Argument Reg                    |
|  Output   |      16       | cmd_setting_reg              | Command Setting Reg                     |
|   Input   |      16       | status_reg                   | Card Status Reg                         |
|   Input   |      32       | cmd_resp_1                   | Command Response                        |
|  Output   |       8       | software_reset_reg           | Software reset Reg                      |
|  Output   |      16       | time_out_reg                 | Timeout Reg                             |
|   Input   |      16       | normal_int_status_reg        | Normal Interrupt Status Reg             |
|   Input   |      16       | error_int_status_reg         | Error Interrupt Status Reg              |
|  Output   |      16       | normal_int_signal_enable_reg | Normal Interrupt Enable Reg             |
|  Output   |      16       | error_int_signal_enable_reg  | Error Interrupt Enable Reg              |
|  Output   |       8       | clock_divider                | Clock Divider Reg                       |
|   input   |      16       | Bd_Status_reg                | BD Status Reg                           |
|   input   |       8       | Bd_isr_reg                   | Data Interrupt Status Reg               |
|  output   |       8       | Bd_isr_enable_reg            | Data Interrupt Enable Reg               |
|  Output   |       1       | Bd_isr_reset                 | Reset data interrupt status             |
|  Output   |       1       | normal_isr_reset             | Reset normal interrupt status           |
|  Output   |       1       | error_isr_reset              | Reset error interrupt status            |
|  Output   | RAM_MEM_WIDTH | dat_in_m_tx_bd               | Data going to the Tx BD                 |
|  Output   | RAM_MEM_WIDTH | dat_in_m_rx_bd               | Data going to the RX BD                 |


### IO Signal Description

The module contain the master wishbone interface signals. 

- `wb_clk_i`:The clock input `wb_clk_i` coordinates all activities for the internal logic within the WISHBONE interconnect. All WISHBONE output signals are registered at the rising edge of `wb_clk_i`.

- `wb_rst_i`:The reset input `wb_rst_i` forces the WISHBONE interface to restart. Furthermore, all registers will be forced into an initial state. The reset values of registers can be found in Register Definition.

- `wb_dat_i`:The data input array `wb_dat_i` is used to pass values to be written to the registers

- `wb_dat_o`:The data output array `wb_dat_o` is used to pass values read from the registers.

- `wb_adr_i`:The address input array `wb_adr_i` is used to pass a binary address. 

- `wb_sel_i`:The select input array `wb_sel_i` indicates where valid data is placed on the `wb_adr_i` signal array during WRITE cycles, and where it should be present on the `wb_adr_o` signal array during READ cycles. (This signal is not used in the module)

- `wb_we_i`:The write enable input `wb_we_i` indicates whether the current local bus cycle is a READ or WRITE cycle. The signal is negated during READ cycles, and is asserted during WRITE cycles.

- `wb_cyc_i`:The cycle input `wb_cyc_i`, when asserted, indicates that a valid bus cycle is in progress.

- `wb_stb_i`:The strobe input `wb_stb_i`, when asserted, indicates that the SLAVE is selected. A SLAVE shall respond to other WISHBONE signals only when this `wb_stb_i` is asserted (except for the `wb_rst_i` signal which should always be responded to). The SLAVE asserts  the `wb_ack_o`, in response to every assertion of the `wb_stb_i`signal.

- `wb_ack_o`:The acknowledge output `wb_ack_o`, when asserted, indicates the termination of a normal bus cycle.

- `we_m_tx_bd`:The write enable output `we_m_tx_bd`, when asserted, indicates the write enable for the master side's TX buffer descriptor.

- `we_m_rx_bd`:The write enable output `we_m_rx_bd`, when asserted, indicates the write enable for the master side's RX buffer descriptor.

- `new_cmd`:This output signal, when asserted, indicates that a command with new parameters has been received.

- `we_ack`:When `sd_data_master` performs block read/write operations, it will assert the `write_req_s` signal. The `we_ack` signal indicates that the write request has been received by `sd_controller_wb` module.

- `int_ack`:This signal is used to delay the `wb_ack_o` signal's return until the multi-cycle operation of accessing the Tx or Rx registers is complete.

- `cmd_int_busy`:The output signal `cmd_int_busy`, when asserted, indicates that the data_master is doing a `cmd_arg` or `cmd_set` access.

- `int_busy`:This signal is set whenever the wishbone makes and access to the cmd_setting_reg register. 

- `write_req_s`:This signal is used to receive the write request signal from `sd_data_master`.

- `cmd_set_s`: This signal is used to receive the command set from `sd_data_master`.

- `cmd_arg_s`: This signal is used to receive the commadd argument from `sd_data_master`.

- The following signal can be accessed through the Wishbone slave's `wb_dat_o` based on the register address.

  - argument_reg
  - cmd_setting_reg
  - status_reg
  - cmd_resp_1
  - controll_setting_reg
  - block_size_reg
  - power_controll_reg
  - software_reset_reg
  - time_out_reg
  - normal_int_status_reg
  - error_int_status_reg
  - normal_int_signal_enable_reg
  - error_int_signal_enable_reg
  - clock_divider
  - capabilies_reg
  - Bd_Status_reg
  - Bd_isr_reg
  - Bd_isr_enable_reg


## Register

| Name               | Address | Width | Access | Description                 |
| ------------------ | ------- | ----- | ------ | --------------------------- |
| Argument           | 0x00    | 32    | RW     | Command Argument Reg        |
| Command Setting    | 0x04    | 16    | RW     | Command Setting Reg         |
| Card Status        | 0x08    | 16    | R      | Card Status Reg             |
| Response           | 0x0c    | 32    | R      | Command Response            |
| Controller Setting | 0x1c    | 16    | R      | Controller Setting          |
| Block Size         | 0x20    | 16    | R      | Block Size Reg              |
| Power Control      | 0x24    | 8     | R      | Power Control Reg           |
| Software reset     | 0x28    | 8     | RW     | Software reset Reg          |
| Timeout            | 0x2c    | 16    | RW     | Timeout Reg                 |
| Normal Int Status  | 0x30    | 16    | RW     | Normal Interrupt Status Reg |
| Error Int Status   | 0x34    | 16    | RW     | Error Interrupt Status Reg  |
| Normal Int Enable  | 0x38    | 16    | RW     | Normal Interrupt Enable     |
| Error Int Enable   | 0x3c    | 16    | RW     | Error Interrupt Enable Reg  |
| Capability         | 0x48    | 16    | R      | Capability Reg              |
| Clock Divider      | 0x4c    | 8     | RW     | Clock Divider Reg           |
| BD buffer Status   | 0x50    | 16    | R     | BD Status Reg               |
| Dat Int Status     | 0x54    | 8    | RW     | Data Interrupt Status Reg   |
| Dat Int Enable     | 0x58    | 8    | RW     | Data Interrupt Enable Reg   |
| BD RX              | 0x60    | 16/32    | W      | BD RX                       |
| BD TX              | 0x80    | 16/32    | W      | BD TX                       |

**Argument Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [31:0] | RW      | CMDA - Command Argument Command Data, when writing to this register the transmission starts |

Reset Value: 0000h

**Command setting Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:14] | Reserved |  |
| [13:8] | RW     | CMDI - Command Index Index of the next command |
| [7:6] | RW     | CMDW – Command Word Select Word to read when response is > 48 Bit |
| 5 | Reserved |  |
| 4 | RW     | CICE - Command index check 0 : Do not perform index check on response CMD 1 : Perform index check on response CMD |
| 3 | RW     | CIRC - Command CRC check 0 : Do not perform CRC check on response CMD 1 : Perform CRC check on response CMD |
| 2 | Reserved |  |
| [1:0] | RW     | RTS – Response type 0: No response 01: Response length 136 10: Response length 48 11: Response length 48 |

Reset Value: 0000h

**Status Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:12] | R      | CST – CMD Host Serial Status 0 : Reset 1 : Write Only state 2: Write to Read State 3: Delay after write to read 4: Delay after write only state 5: Read CMD |
| [11:1] | Reserved |  |
| 0 | R      | CICMD – Command Inhibit 1 : Busy 0 : Ready |

Reset Value: 0000h

**Response Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [31:0] | R      | CRSP – Command Response Response of last command |

Reset Value:0000h

**Controller settings**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:0] | Not in use |  |

Reset Value: 0000h

**Block Size**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:12] | Reserved |  |
| [11:0] | R      | BS - Block Size Currently Hard coded to 512. Value has no effect on the operation. |

Reset Value: 0200h

**Power control**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [7:3] | Reserved |  |
| [3:0] | R      | SDBP – SD Bus power Voltage provided to bus 1111 : 3.3 V 1101 : 3 V 1011 : 1.8 V.  We choose 3.3V. |

Reset Value: 0000fh

**Software Reset**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [7:1] | Reserved |  |
| 0 | RW      | SRST – Software reset 0: 1: Reset the hardware |

Reset Value: 0000h

**Timeout Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:0] | RW     | CTO – Command timeout Time before a timeout signal is generated when sending, counted with the system clock. |

Reset Value: 0000h

**Normal Interrupt Status Reg**

Writing any value to this register resets it 0000h

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| 15 | RW     | EI – Error interrupt If any of the bits in the Error Interrupt Status register are set, then this bit is |
| [14:1] | Reserved |  |
| 0 | RW     | CC – Command Complete This bit is set when get the end bit of the command response. |

**Error Interrupt Status Reg**

Writing any value to this register resets it 0000h

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:4] | Reserved |  |
| 3 | RW     | CIE – Command index error This bit is set if a Command Index error occurs in the command response. |
| 2 | Reserved |  |
| 1 | RW     | CCRC – Command CRC error This bit is set when a command CRC check fail |
| 0 | RW     | CTE – Command Timeout This bit is set when a command sequence timeout occur |

**Normal Interrupt Enable Reg**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| 15 | RW     | EEI – Enable Error interrupt 1 : Enable interrupt generation on EI 0 : Disable interrupt generation on EI |
| [14:1] | Reserved |  |
| 0 | RW     | ECC – Enable Command Complete 1 : Enable interrupt generation on ECC 0 : Disable interrupt generation on ECC |

**Error Interrupt Enable Reg**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:4] | Reserved |  |
| 3 | RW     | ECIE – Command index error 1 : Enable interrupt generation on CIE 0 : Disable interrupt generation on CIE |
| 2 | Reserved |  |
| 1 | RW     | ECCRC – Command CRC error 1 : Enable interrupt generation on CCRC 0 : Disable interrupt generation on CCRC |
| 0 | RW     | ECTE – Command Timeout 1 : Enable interrupt generation on CTE 0 : Disable interrupt generation on CTE |

**Capability register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:0] | Reserved |  |

Reset Value: 0000h


**Clock Divider Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [7:0] | CLKD – Clock Divider | Divide the modules SD input clock 0: Divided by 2 1: Divided by 4 2: Divided by 6. |

Reset Value: 0000h

**BD Buffer Status Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [15:8] | R      | FBRX – Free RX Buffer Descriptors NO free receiving buffer Descriptors |
| [7:0] | R      | FBTX – Free TX Buffer Descriptors NO free transmission buffer Descriptors |

Reset Value: 0404h

**Data Interrupt Status Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [7:6] | Reserved |  |
| 5 | RW     | TRE – Transmission Error 1 : CRC check failed during transmission 0 : No error |
| 4 | RW     | CMDE – Command error 1 : Error in the command response 0 : No error |
| 2 | RW     | FIFOE - FIFO error 1 : FIFO underflow/overflow 0 : No error |
| 1 | RW     | MRC – Max Retry Attempts reached 1 : Unable to send after N attempts 0 : Not reached |
| 0 | RW     | TRS – Transmission successful 1 : One data block has been sent/received 0 : Not successful |

Reset Value: 0000h

**Data Interrupt Enable Register**

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [7:6] | Reserved |  |
| 5 | RW     | ETRE – Transmission Error 1 : Enable interrupt generation on TRE 0 : Disable interrupt generation on TRE |
| 4 | RW     | ECMDE – Command error 1 : Enable interrupt generation on CMDE 0 : Disable interrupt generation on CMDE |
| 2 | RW     | EFIFOE - FIFO error 1 : Enable interrupt generation on FIFOE 0 : Disable interrupt generation on FIFOE |
| 1 | RW     | EMRC – Max Retry Attempts reached 1 : Enable interrupt generation on MRC 0 : Disable interrupt generation on MRC |
| 0 | RW     | ETRS – Transmission successful 1 : Enable interrupt generation on TRS 0 : Disable interrupt generation on TRS |

Reset Value: 0000h

**BD RX**

Writing any value to this register resets it to 0000h

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [63:32] | W      | Memory location where the data should be stored |
| [31:0] | W      | Block address to read from |

Reset Value: 0000h

**BD TX**

Writing any value to this register resets it to 0000h

| Bit # | Access | Description                     |
| ----- | ------ | ------------------------------- |
| [63:32] | W      | Memory location where the data should be read from |
| [31:0] | W      | Block address to write to |

Reset Value: 0000h

## Operation


### Control Logic

- **cmd_int_busy** is set whenever the data_master is doing a **cmd_arg** or **cmd_set** access. 
- **int_busy** is set whenever the wishbone makes and access to the `cmd_arg` register.
- **new_cmd** is set whenever the **cmd_arg** is set.
- **we_ack**  is asserted in response to the `write_req_s` signal.
- **wb_ack_o** is asserted if wb_cyc_i & wb_stb_i & ~wb_ack_o & int_ack
- **int_ack** signal defaults to high. When writing to `bd_rx` or `bd_tx`, it is set low and returns to high once the write operation is complete.
- **we_m_rx_bd** signal defaults to low. It goes high when writing to the `bd_tx` or `bd_rx` registers, and resets to low after the write is complete.

### Reset  and Clock

This module uses a synchronous design and an **asynchronous** reset method, with variables updated on the rising edge of the clock signal and the reset signal being active **high**. 

When `wb_rst_i` is asserted, this module immediately resets all variables to their reset value.  There are two types of situations: 

- configuration registers: Configuration-related registers are reset to their default values as described in the Register section.
- other variables: Except for `int_ack` which will be reset to 1, other variables are reset to 0.

### Functional Description

#### Register Write

The module has a slave wishbone interface, for the register writing.

- Condition: `wb_stb_i` is high,  indicating that this slave module is selected, `wb_cyc_i` is high, indicating that a valid bus cycle is in progress **and** `wb_we_i` is asserted.
- Action: Based on the input address `wb_adr_i`, the corresponding register will be written with the value from `wb_dat_i`. For registers with a width of 1, the value will be set high.
  - For the `bd_tx` and `bd_rx` registers, first enable `we_m_(t/r)x_bd` and negate `int_ack`. If the RAM width is 32 bits, a single write is sufficient. If the RAM width is 16 bits, write the lower 16 bits first, then the upper 16 bits. Finally, assert the `int_ack` signal and reset the write enable `we_m_xx_bd`. The **wb_ack_o** is not generated until the whole Bd has been writen . 


#### Register Read

The module has a slave wishbone interface, for the register reading.

- Condition: If `wb_stb_i` is high,  indicating that this slave module is selected **and** `wb_cyc_i` is high, indicating that a valid bus cycle is in progress.
- Action: Select the corresponding register based on `wb_adr_i`, and assign the value of this register to `wb_dat_o`. The addresses of the registers are specified in the Register section.
- Purpose: When the module is in operation, return the value of the corresponding register based on the address.

### 






