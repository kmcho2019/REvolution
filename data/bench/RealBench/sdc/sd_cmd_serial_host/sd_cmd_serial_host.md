# sd_cmd_serial_host design  specification

## Introduction

**Design Overview**

The sd_cmd_serial_host module is an interface to the external SD /MMC card. It is used to read and write command to the SD/MMC card. The external interface consist of two signals clk and a bidirectional signal CMD. The cmd_out_o, cmd_dat_i and cmd_oe_o signals has to be combined in additional module (Preferable the SoC top module). 

**Functional Block**

The module consist of 6 block, FSM_COMBO, REQ_SYNC, ACK_SYNC,COMMAND_DECODER, FSM_OUT and FSM_SEQ. 

FSM_COMBO is combinatorial logic to calculate the next state of the FSM. FSM_SEQ is the sequntial part of the FSM and it sets the state synchronized with the clock. REQ_SYNC and ACK_SYNC is 2 flipflop used to reduce chance for metastable state when signals cross clock domains. COMMAND_DECODER read the SETTING_IN vector and store the settings and command to internal register, which is used in the FSM_OUT. The FSM_OUT is the output logic of the FSM.

1. **FSM_COMBO**
   - **Function**: Combinational logic to determine the next state of the finite state machine (FSM) based on current state and input conditions.
   - **Data Flow**: Evaluates inputs such as `state`, `Delay_Cnt`, `Write_Read`, `Cmd_Cnt`, `Write_Only`,`Ack_internal_in`, `cmd_dat_i` , `Response_Size` , `Delay_Cycleand` to compute `next_state`.
   - **Clock Conditions**: Operates combinationally without clock dependency.
2. **FSM_SEQ**
   - **Function**: Sequential logic that updates the current state of the FSM on each rising edge of `SD_CLK_IN` or when `RST_IN` is asserted.
   - **Data Flow**: On each clock cycle, `state` is updated to `next_state`.
   - **Clock Conditions**: Triggered on the rising edge of `SD_CLK_IN` or `RST_IN`.
3. **REQ_SYNC**
   - **Function**: Synchronizes the asynchronous `REQ_IN` signal to the local clock domain to prevent metastability.
   - **Data Flow**: Uses a two-flip-flop synchronizer to convert `REQ_IN` into `Req_internal_in`.
   - **Clock Conditions**: Triggered on the rising edge of `SD_CLK_IN` or `RST_IN`.
4. **ACK_SYNC**
   - **Function**: Synchronizes the asynchronous `ACK_IN` signal to the local clock domain to prevent metastability.
   - **Data Flow**: Uses a two-flip-flop synchronizer to convert `ACK_IN` into `Ack_internal_in`.
   - **Clock Conditions**:Triggered on the rising edge of `SD_CLK_IN` or `RST_IN`.
5. **COMMAND_DECODER**
   - **Function**: Decodes the `SETTING_IN` register and prepares internal settings and buffers for command transmission.
   - **Data Flow**: Extracts command settings, determines if the command is a read or write, and sets up buffers (`In_Buff`, `Out_Buff`) accordingly.
   - **Clock Conditions**: Triggered on the rising edge of `SD_CLK_IN` or `RST_IN`.
6. **FSM_OUT**
   - **Function**: Manages the output logic based on the current state of the FSM.
   - **Data Flow**: Controls outputs such as `CMD_OUT`, `ACK_OUT`, `REQ_OUT`, and handles CRC operations.
   - **Clock Conditions**: Triggered on the rising edge of `SD_CLK_IN` or `RST_IN`.

## Interface

### Input Ports

| **Name**     | **Width** | **Description**                                |
| ------------ | --------- | ---------------------------------------------- |
| `SD_CLK_IN`  | 1         | Clock signal for SD interface synchronization. |
| `RST_IN`     | 1         | Synchronous reset signal (active high).        |
| `SETTING_IN` | 16        | Settings for the current command.              |
| `CMD_IN`     | 40        | Command to be sent to the SD/MMC card.         |
| `REQ_IN`     | 1         | Request signal for service initiation.         |
| `ACK_IN`     | 1         | Acknowledgment signal for service completion.  |
| `cmd_dat_i`  | 1         | Command data input from the SD/MMC card.       |

### Output Ports

| **Name**    | **Width** | **Description**                                      |
| ----------- | --------- | ---------------------------------------------------- |
| `CMD_OUT`   | 40        | Command output to be sent to the SD/MMC card.        |
| `ACK_OUT`   | 1         | Acknowledgment signal for service completion.        |
| `REQ_OUT`   | 1         | Request signal to initiate service.                  |
| `STATUS`    | 8         | Status register indicating module state and flags.   |
| `cmd_oe_o`  | 1         | Tri-state control for CMD output enable.             |
| `cmd_out_o` | 1         | Command output enable signal to SD/MMC card.         |
| `st_dat_t`  | 2         | Start data transfer signal indicating transfer type. |

###  Signal Description

Because the data cross a clock domain the signals is synchronized with **REQ** and **ACK** signals. **REQ_IN** is set to high when a service is requested, the module answer with setting **ACK_OUT** to low, as long as **ACK_OUT** is high the **SETTING_IN** and **CMD_IN** should not change. **ACK_OUT** is kept low until a **CMD** cycle is completed. When the Module has data to send ( like updated **STATUS** or valid data in **CMD_OUT)** the module assert **REQ_OUT** and wait for **ACK_IN** to go high before doing any further operation.

###  Signal Description
**Setting_in register**

| Bits  | 15       | [14:13]     | 12         | 11          | [10:8]        | 7                | [6:0]         |
| ----- | -------- | ----------- | ---------- | ----------- | ------------- | ---------------- | ------------- |
| Width | 1        | 2           | 1          | 1           | 3             | 1                | 7             |
|       | Reserved | Word Select | Block Read | Block Write | Timing Values | CRC-Check ON/OFF | Response Size |

**status register**

| Bits  | [15:7]   | 6              | 5         | 4              | [3:0] |
| ----- | -------- | -------------- | --------- | -------------- | ----- |
| Width | 8        | 1              | 1         | 1              | 4     |
|       | Reserved | Data Available | CRC-valid | CMD status L/H | State |

## Internal Constants and Parameters

The module utilizes several internal constants and parameters to manage state transitions and operational settings:

**internal constants**

| **Name**                                                     | **Value**                                               | **Description**                                              |
| ------------------------------------------------------------ | ------------------------------------------------------- | ------------------------------------------------------------ |
| `INIT_DELAY`                                                 | `2` (SIM) / `64` (Other)                                | Number of cycles to keep the CMD line high during initialization. |
| `NCR`                                                        | `2`                                                     | Number of cycles required for write delay.                   |
| `SEND_SIZE`                                                  | `48`                                                    | Total number of bits to send for a complete command transmission, including CRC and stop bit. |
| `SIZE`                                                       | `10`                                                    | Width of the state variable for FSM.                         |
| `CONTENT_SIZE`                                               | `40`                                                    | Size of the internal command buffer (`In_Buff` and `Out_Buff`). |
| `Read_Delay`                                                 | `7`                                                     | Number of cycles to delay before processing read response.   |
| `EIGHT_PAD`                                                  | `8`                                                     | Number of padding bits used in response handling.            |
| `INIT`, `IDLE`, `WRITE_WR`, `DLY_WR`, `READ_WR`, `DLY_READ`, `ACK_WR`, `WRITE_WO`, `DLY_WO`, `ACK_WO` | Binary values representing different states of the FSM. | States for managing command transmission and reception in the FSM. |

**Internal Signals**

The module maintains several internal signals to manage command processing, CRC operations, and state transitions:

| **Name**              | **Width** | **Type** | **Description**                                              |
| --------------------- | --------- | -------- | ------------------------------------------------------------ |
| `Response_Size`       | 7         | Reg      | Stores the size of the expected response from the SD/MMC card. |
| `Delay_Cycler`        | 3         | Reg      | Counter for managing delay cycles during state transitions.  |
| `In_Buff`             | 40        | Reg      | Internal buffer holding the incoming command data (`CMD_IN`). |
| `Out_Buff`            | 40        | Reg      | Internal buffer for storing the outgoing command response data. |
| `Write_Read`          | 1         | Reg      | Flag indicating a write operation expecting a read response. |
| `Write_Only`          | 1         | Reg      | Flag indicating a write-only operation without expecting a read response. |
| `word_select_counter` | 5         | Reg      | Counter for managing word selection during CRC operations.   |
| `CRC_RST`             | 1         | Reg      | Signal to reset the CRC computation unit.                    |
| `CRC_IN`              | 7         | Reg      | Input data for CRC computation.                              |
| `CRC_VAL`             | 7         | Wire     | Output CRC value computed by the `sd_crc_7` module.          |
| `CRC_Enable`          | 1         | Reg      | Enable signal for the CRC computation unit.                  |
| `CRC_OUT`             | 1         | Reg      | Output signal from the CRC computation unit indicating CRC bit transmissions. |
| `CRC_Check_On`        | 1         | Reg      | Flag indicating whether CRC checking is enabled for the current command. |
| `Crc_Buffering`       | 1         | Reg      | Flag indicating if CRC data is being buffered.               |
| `CRC_Valid`           | 1         | Reg      | Flag indicating the validity of the received CRC.            |
| `Cmd_Cnt`             | 8         | Reg      | Counter for tracking the number of command bits sent or received. |
| `Delay_Cnt`           | 3         | Reg      | Counter for managing delay states and transitions.           |
| `state`               | 10        | Reg      | Current state of the FSM.                                    |
| `next_state`          | 10        | Reg      | Next state of the FSM as determined by `FSM_COMBO`.          |
| `block_write`         | 1         | Reg      | Flag indicating a block write operation.                     |
| `block_read`          | 1         | Reg      | Flag indicating a block read operation.                      |
| `word_select`         | 2         | Reg      | Signals for selecting specific words during data transfer.   |
| `FSM_ACK`             | 1         | Reg      | Acknowledgment flag for FSM operations.                      |
| `DECODER_ACK`         | 1         | Reg      | Acknowledgment flag for the command decoder completion.      |
| `q`                   | 1         | Reg      | Intermediate flip-flop for synchronizing `REQ_IN`.           |
| `Req_internal_in`     | 1         | Reg      | Synchronized internal request signal after crossing clock domains. |
| `q1`                  | 1         | Reg      | Intermediate flip-flop for synchronizing `ACK_IN`.           |
| `Ack_internal_in`     | 1         | Reg      | Synchronized internal acknowledgment signal after crossing clock domains. |

## Function Blocks

### FSM_COMBO

**State Transition Table**

The following table outlines the possible state transitions based on current state and input conditions.

| **Current State** | **Input Conditions**                     | **Next State** | **Description**                                         |
| ----------------- | ---------------------------------------- | -------------- | ------------------------------------------------------- |
| INIT              | `Cmd_Cnt >= INIT_DELAY`                  | IDLE           | Transition to IDLE after initialization delay.          |
| INIT              | Otherwise                                | INIT           | Remain in INIT state.                                   |
| IDLE              | `Write_Read` asserted                    | WRITE_WR       | Start write with read response.                         |
| IDLE              | `Write_Only` asserted                    | WRITE_WO       | Start write without read response.                      |
| IDLE              | Otherwise                                | IDLE           | Remain in IDLE state.                                   |
| WRITE_WR          | `Cmd_Cnt >= SEND_SIZE - 1`               | DLY_WR         | Transition to write delay after sending.                |
| WRITE_WR          | Otherwise                                | WRITE_WR       | Continue writing.                                       |
| WRITE_WO          | `Cmd_Cnt >= SEND_SIZE - 1`               | DLY_WO         | Transition to write-only delay.                         |
| WRITE_WO          | Otherwise                                | WRITE_WO       | Continue write-only operation.                          |
| DLY_WR            | `Delay_Cnt >= NCR` and `!cmd_dat_i`      | READ_WR        | Transition to read write response delay.                |
| DLY_WR            | Otherwise                                | DLY_WR         | Continue in write delay state.                          |
| DLY_WO            | `Delay_Cnt >= Delay_Cycler`              | ACK_WO         | Transition to acknowledge write-only.                   |
| DLY_WO            | Otherwise                                | DLY_WO         | Continue in write-only delay state.                     |
| READ_WR           | `Cmd_Cnt >= (Response_Size + EIGHT_PAD)` | DLY_READ       | Transition to read delay after receiving response.      |
| READ_WR           | Otherwise                                | READ_WR        | Continue reading response.                              |
| DLY_READ          | `Ack_internal_in` asserted               | ACK_WR         | Transition to acknowledge read response.                |
| DLY_READ          | Otherwise                                | DLY_READ       | Continue in read delay state.                           |
| ACK_WO            | Any                                      | IDLE           | Transition back to IDLE after acknowledging write-only. |
| ACK_WR            | Any                                      | IDLE           | Transition back to IDLE after acknowledging read.       |
| Default           | Any condition not listed                 | INIT           | Default to INIT to ensure safe state.                   |

### FSM_SEQ

**Reset Condition (`RST_IN` High)**:

- The FSM state is set to `INIT`, regardless of the current state.
- Ensures the FSM starts in a known, stable state upon reset.

**Normal Operation (`RST_IN` Low)**:

- On each rising edge of `SD_CLK_IN`, the current state `state` transitions to `next_state`.
- `next_state` is determined by the combinational logic in the `FSM_COMBO` block.

### REQ_SYNC
Synchronize conditions：posedge `SD_CLK_IN` or posedge `RST_IN`.
1. **Reset Condition**: `RST_IN` High
- **Action:** Initialize synchronization registers `Req_internal_in` and `q` to `0`.
**Purpose**: Ensures that the module starts in a known, stable state.

2. **Normal Operation**:On each rising edge of `SD_CLK_IN`
- The intermediate flip-flop `q` captures the current value of `REQ_IN`.
- Subsequently, `Req_internal_in` captures the value of `q`.
- **Purpose**: Transitions `REQ_IN` through two flip-flops to safely synchronize it to the local clock domain, mitigating the risk of metastability.

### ACK_SYNC

1. ** Reset Condition**:`RST_IN` High
- **Action:** both `q1` and `Ack_internal_in` are reset to `0`.
- **Purpose**: Ensures that the module starts in a known, stable state.

2. **Normal Operation**: On each rising edge of  `SD_CLK_IN`
- The intermediate flip-flop `q1` captures the current value of `ACK_IN`.
- Subsequently, `Ack_internal_in` captures the value of `q1`.
- **Purpose**: Transitions `ACK_IN` through two flip-flops to safely synchronize it to the local clock domain, mitigating the risk of metastability.

### COMMAND_DECODER

**Reset Condition (`RST_IN` High)**:
- Resets all internal registers and flags: `Delay_Cycler`, `Response_Size`, `DECODER_ACK`, `Write_Read`, `Write_Only`, `CRC_Check_On`, `In_Buff`, `block_write`, `block_read`, `word_select` are all set to `0`.
- **Purpose**: Initializes the module to a known state, ensuring no residual data or flags affect subsequent operations.

**Command Decoding**: `Req_internal_in` is asserted (`1`), indicating a synchronized request for command processing.
  - Decode `SETTING_IN`:
    - `Response_Size` <= `SETTING_IN[6:0]`
    - `CRC_Check_On` <= `SETTING_IN[7]`
    - `Delay_Cycler` <= `SETTING_IN[10:8]`
    - `block_write` <= `SETTING_IN[11]`
    - `block_read` <= `SETTING_IN[12]`
    - `word_select` <= `SETTING_IN[14:13]`
  - Load Command Data:
    - `In_Buff` <= `CMD_IN`
  - Set Operation Flags:
    - If `SETTING_IN[6:0] > 0`:
      - `Write_Read` <= `1`
      - `Write_Only` <= `0`
    - Else:
      - `Write_Read` <= `0`
      - `Write_Only` <= `1`
  - Manage Acknowledgment:
    - `DECODER_ACK` <= `0` (indicating decoding in progress)
- **Purpose**: Prepares internal settings and buffers based on the incoming command configuration for accurate command transmission.

**Decoding Completion**: `Req_internal_in` is  Low, indicating no ongoing decoding request.
- Actions:
  - `Write_Read` <= `0`
  - `Write_Only` <= `0`
  - `DECODER_ACK` <= `1` (indicating decoding is complete)
- **Purpose**: Resets operation flags and acknowledges the completion of the decoding process, allowing the FSM to proceed with command transmission.

### FSM_OUT

The `FSM_OUT` module is responsible for managing the output signals and internal counters based on the current FSM state. It handles CRC operations, manages counters, controls the CMD line, and updates status registers.

**Reset Condition (`RST_IN` High)**

When a reset is asserted, all internal registers and control signals are initialized to their default states to ensure the module starts in a known and stable condition.

| **Signal**            | **Initial Value** | **Description**                                         |
| --------------------- | ----------------- | ------------------------------------------------------- |
| `CRC_Enable`          | `0`               | Disables the CRC computation unit.                      |
| `word_select_counter` | `0`               | Resets the word selection counter.                      |
| `Delay_Cnt`           | `0`               | Resets the delay counter.                               |
| `cmd_oe_o`            | `1`               | Enables the CMD line output (high-impedance state off). |
| `cmd_out_o`           | `1`               | Asserts the CMD output high to maintain idle state.     |
| `Out_Buff`            | `0`               | Clears the outgoing command buffer.                     |
| `FSM_ACK`             | `1`               | Asserts FSM acknowledgment.                             |
| `REQ_OUT`             | `0`               | Deasserts the request output signal.                    |
| `CRC_RST`             | `1`               | Resets the CRC computation unit.                        |
| `CRC_OUT`             | `0`               | Clears the CRC output signal.                           |
| `CRC_IN`              | `0`               | Clears the CRC input register.                          |
| `CMD_OUT`             | `0`               | Clears the CMD output data.                             |
| `Crc_Buffering`       | `0`               | Disables CRC buffering.                                 |
| `STATUS`              | `0`               | Resets the status register.                             |
| `CRC_Valid`           | `0`               | Disables CRC validation.                                |
| `Cmd_Cnt`             | `0`               | Resets the command counter.                             |
| `st_dat_t`            | `0`               | Resets the start data transfer type signal.             |

**Detailed Operations by State**

**INIT State**: Initialize the module by keeping the CMD line active for a predefined number of cycles.

- Increment `Cmd_Cnt` by 1 on each clock cycle.
- Keep `cmd_oe_o` and `cmd_out_o` asserted (`1`) to maintain the CMD line in an active state.

**IDLE State**: Await new command requests.

- Deassert `cmd_oe_o` to place the CMD line in a high-impedance state (`0`).
- Reset counters: `Delay_Cnt` and `Cmd_Cnt` to `0`.
- Reset CRC-related signals: `CRC_RST = 1`, `CRC_Enable = 0`, `CMD_OUT = 0`.
- Clear `st_dat_t` and `word_select_counter`.

**WRITE_WR State**: Send a write command expecting a read response.

- Deassert `FSM_ACK` (`0`) to indicate the FSM is processing the write operation.
- Disable CRC reset and enable CRC computation (`CRC_RST = 0`, `CRC_Enable = 1`).
- Command Transmission:
  - If `Cmd_Cnt == 0`: Set `STATUS` to `16'b0000_0000_0000_0001`, indicating a write operation. Assert `REQ_OUT` (`1`) to initiate the command transmission.
  - Else if `Ack_internal_in` is asserted: Deassert `REQ_OUT` (`0`) to stop requesting the service.
  - CRC Buffering and Bit Transmission:

    If `Crc_Buffering == 1`:

    - Assert `cmd_oe_o` (`1`) to enable CMD output.
    - If `Bit_Nr > 8`: Transmit command bits and if `Bit_Nr > 9`, manage CRC output.
    - Else if `Bit_Nr <= 8 && Bit_Nr >= 2`: Transmit CRC bits and update `st_dat_t` based on operation type.
    - Else: Maintain CMD line high (`cmd_out_o = 1`).
    - Increment `Cmd_Cnt` by 1.

    Else:
    - Pre-load CRC by setting `Crc_Buffering = 1`.
    - Assign `CRC_OUT` from `In_Buff` based on `Vector_Index`.

**WRITE_WO State**: Send a write-only command without expecting a read response.

- Similar to `WRITE_WR` state with adjustments for write-only operations. Deassert `FSM_ACK` (`0`) to indicate the FSM is processing the write operation. Disable CRC reset and enable CRC computation (`CRC_RST = 0`, `CRC_Enable = 1`).

- If `Cmd_Cnt == 0`: Set `STATUS[3:0]` to `4'b0010`, indicating a write-only operation. Assert `REQ_OUT` (`1`) to initiate the command transmission. Else if `Ack_internal_in` is asserted: Deassert `REQ_OUT` (`0`) to stop requesting the service.
- CRC Buffering and Bit Transmission:

  If `Crc_Buffering == 1`:
  - Assert `cmd_oe_o` (`1`) to enable CMD output.
  - Transmit command bits and manage CRC output similarly to `WRITE_WR`.
  - Set `st_dat_t` based on `block_read` flag.
  - Increment `Cmd_Cnt` by 1.

  Else:
  - Pre-load CRC by setting `Crc_Buffering = 1`.
  - Assign `CRC_OUT` from `In_Buff` based on `Vector_Index`.

**DLY_WR State**: Introduce a delay after sending a write command.

- If `Delay_Cnt == 0`:
  - Set `STATUS[3:0]` to `4'b0011`, indicating a delay after write.
  - Assert `REQ_OUT` (`1`) to initiate the next operation.
- Else if `Ack_internal_in` is asserted:
  - Deassert `REQ_OUT` (`0`) to stop requesting the service.
- Disable CRC computation and reset (`CRC_Enable = 0`, `CRC_RST = 1`). 
- Set `Cmd_Cnt` to `1`.
- Deassert `cmd_oe_o` (`0`) to place CMD line in high-impedance state.
- If `Delay_Cnt < 3'b111`: Increment `Delay_Cnt` by 1.
- Disable CRC buffering (`Crc_Buffering = 0`).

**DLY_WO State**: Introduce a delay after sending a write-only command.

- If `Delay_Cnt == 0`:
  - Set `STATUS[3:0]` to `4'b0100`, indicating a delay after write-only.
  - Clear `STATUS[5]` and set `STATUS[6]` to `1`.
  - Assert `REQ_OUT` (`1`) to initiate the next operation.
- Else if `Ack_internal_in` is asserted:
  - Deassert `REQ_OUT` (`0`) to stop requesting the service.
- Disable CRC computation and reset (`CRC_Enable = 0`, `CRC_RST = 1`).
- Set `Cmd_Cnt` to `0`.
- Deassert `cmd_oe_o` (`0`) to place CMD line in high-impedance state.
- Increment `Delay_Cnt` by 1.
- Disable CRC buffering (`Crc_Buffering = 0`).

**READ_WR State**: Receive and process the read response from the SD/MMC card.

- Reset `Delay_Cnt` to `0`.
- Disable CRC reset and enable CRC computation (`CRC_RST = 0`, `CRC_Enable = 1`).
- Deassert `cmd_oe_o` (`0`) to place CMD line in high-impedance state.
- If `Cmd_Cnt == 1`:
  - Set `STATUS[3:0]` to `4'b0101`, indicating a read operation.
  - Assert `REQ_OUT` (`1`) to initiate the read response reception.
  - Set `Out_Buff[39] = 0` to mark the start bit.
- Else if `Ack_internal_in` is asserted:
  - Deassert `REQ_OUT` (`0`) to stop requesting the service.
- Response Reception:
  - If `Cmd_Cnt < Response_Size`:
    - Capture incoming data bits (`cmd_dat_i`) into `Out_Buff` based on `Cmd_Cnt` and `word_select`.
    - Assign `CRC_OUT` from `cmd_dat_i` for CRC computation.
  - Else if `(Cmd_Cnt - Response_Size) <= 6`:
    - Assign `CRC_IN` from `cmd_dat_i` based on the reduced count.
    - Disable CRC computation (`CRC_Enable = 0`).
  - Else:
    - Validate CRC:
      - If `(CRC_IN != CRC_VAL)` and `CRC_Check_On == 1`:
        - Set `CRC_Valid = 0`.
        - Disable CRC (`CRC_Enable = 0`).
      - Else:
        - Set `CRC_Valid = 1`.
        - Disable CRC (`CRC_Enable = 0`).
    - Update `st_dat_t` based on `block_read` and `block_write` flags:
      - If both `block_read` and `block_write` are asserted:
        - Set `st_dat_t = 2'b11`.
      - Else if `block_write` is asserted:
        - Set `st_dat_t = 2'b01`.
    - Increment `Cmd_Cnt` by 1.

**DLY_READ State**: Finalize the read response processing.

- If `Delay_Cnt == 0`:
  - Set `STATUS[3:0]` to `4'b0110`, indicating completion of read delay.
  - Set `STATUS[5]` to `CRC_Valid` and `STATUS[6]` to `1`.
  - Assert `REQ_OUT` (`1`) to signal completion.
- Else if `Ack_internal_in` is asserted:
  - Deassert `REQ_OUT` (`0`) to stop requesting the service.
- Disable CRC computation and reset (`CRC_Enable = 0`, `CRC_RST = 1`).
- Clear `Cmd_Cnt` and deassert `cmd_oe_o` (`0`).
- Assign `CMD_OUT` with the contents of `Out_Buff`.
- Increment `Delay_Cnt` by 1.

**ACK_WO State**: Acknowledge the completion of a write-only operation.

- Assert `FSM_ACK` (`1`).

**ACK_WR State**:** Acknowledge the completion of a read operation.

- Assert `FSM_ACK` (`1`).
- Deassert `REQ_OUT` (`0`).


## Clock and Reset

### Clock

- **Signal**: `SD_CLK_IN`
- **Description**: The main clock signal for the `sd_cmd_serial_host` module, driving all synchronous operations including state transitions, signal synchronization, and CRC computations.

### Reset

- **Signal**: `RST_IN`
- **Description**: A synchronous reset signal that, when asserted, initializes the module's internal registers, counters, and control signals to their default states. This ensures the module starts in a known and stable state.

### Operation

- **Clock Conditions**: All synchronous operations are triggered on the rising edge of `SD_CLK_IN`.
- **Reset Conditions**: When `RST_IN` is asserted, the module immediately resets all internal states and outputs, regardless of the clock.

## Submodules

### sd_crc_7

#### Description

The `sd_crc_7` module is designed to compute a 7-bit Cyclic Redundancy Check (CRC) value for serial data inputs. It processes incoming bits serially, updating the CRC value based on the current input bit and the previous CRC state. This module is critical for error detection in data transmission systems where data integrity is paramount.

#### Interface

**Inputs**

- BITVAL (input): The next input bit to be processed for CRC computation.
- Enable (input): A control signal that enables the CRC update on the rising edge of the clock. When high (1), the CRC is updated; otherwise, it remains unchanged.
- CLK (input): The clock signal that synchronizes the CRC computation. The CRC value updates on the rising edge of this clock.
- RST (input): The reset signal. When asserted high (1), it initializes the CRC value to zero.

**Outputs**

- CRC (output [6:0]): The current 7-bit CRC value.




## Corner Cases

### Metastability in Signal Synchronization

- **Issue**: Asynchronous `REQ_IN` and `ACK_IN` signals may cause metastability when transitioning between clock domains.
- **Handling**: The `REQ_SYNC` and `ACK_SYNC` blocks employ two-stage flip-flop synchronizers to safely synchronize these signals to the local `SD_CLK_IN` clock domain, minimizing the risk of metastability.

### CRC Validation Failures

- **Issue**: Received CRC does not match the computed CRC, indicating data corruption.
- **Handling**: In the `READ_WR` state, if `CRC_IN` does not match `CRC_VAL` and CRC checking is enabled (`CRC_Check_On`), the module deasserts `CRC_Valid` and manages error flags accordingly.

### Command Timeout

- **Issue**: Command execution exceeds the specified timeout (`INIT_DELAY`), potentially due to communication issues with the SD/MMC card.
- **Handling**: The FSM monitors `Cmd_Cnt` against `SEND_SIZE` and transitions to appropriate delay states. If delays exceed `NCR` or `Delay_Cycler`, it handles transitions to acknowledgment states and manages error flags.

### Simultaneous Read and Write Operations

- **Issue**: Attempting to perform a read and write operation simultaneously may cause signal conflicts.
- **Handling**: The module uses mutually exclusive flags (`Write_Read` and `Write_Only`) to ensure that only one type of operation occurs at a time, preventing conflicts.

### High-Impedance CMD Line

- **Issue**: Improper release of the CMD line can lead to bus contention or undefined states.
- **Handling**: The FSM ensures that `cmd_oe_o` is correctly deasserted in the `IDLE` state, placing the CMD line in a high-impedance state (`Z`) when not actively transmitting commands.
