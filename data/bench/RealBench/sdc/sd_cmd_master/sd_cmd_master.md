# sd_cmd_master design specification

This specification provides a comprehensive overview of the sd_cmd_master module, detailing its functionality, interfaces, internal dataflow, and operational constraints. Adhering to this specification ensures proper integration and reliable operation within the SD/MMC controller IP core.

## Introduction

**Function Description**

The SD CMD Master module synchronize the communication from the host interface with the physical interface. Perform has three main tasks:

- Read a set of register from the user accessible register in the SD Controller Top to compose a 40 bit command messages to pass to the SD CMD 

- Read response messages from the SD CMD Host and forward it to the user accessible register in the SD Controller Top module. 

- Keep track of the status of the CMD Host module. 

**Design Overview**

The `sd_cmd_master` module operates as a finite state machine (FSM) with three primary states: `IDLE`, `SETUP`, and `EXECUTE`. It interfaces with various registers such as `ARG_REG`, `CMD_SET_REG`, and `TIMEOUT_REG` to configure and execute commands. The module also handles interrupt generation and status updates based on command execution results.

**Functional Block**

The `sd_cmd_master` module comprises several functional blocks that work cohesively to manage SD card commands:

1. **Debounce Logic**: Ensures stable detection of the SD card presence by filtering rapid fluctuations in the `card_detect` signal.
2. **Synchronization**: Synchronizes asynchronous input signals (`req_in` and `ack_in`) to the module's clock domain to prevent metastability.
3. **Finite State Machine (FSM)**: Manages the states of command processing, transitioning between IDLE, SETUP, and EXECUTE states based on inputs and internal conditions.
4. **FSM State operation**: Maintains and updates status registers  based on operational outcomes and error conditions.

## Interface

### IO Ports

| Direction | Width | Name             | Description                                    |
| --------- | ----- | ---------------- | ---------------------------------------------- |
| Input     | 1     | `CLK_PAD_IO`     | Clock input                                    |
| Input     | 1     | `RST_PAD_I`      | Asynchronous reset, active high                |
| Input     | 1     | `New_CMD`        | Signal indicating a new command is available   |
| Input     | 1     | `data_write`     | Indicates a block write command                |
| Input     | 1     | `data_read`      | Indicates a block read command                 |
| Input     | 32    | `ARG_REG`        | Command argument register                      |
| Input     | 14    | `CMD_SET_REG`    | Command settings register                      |
| Input     | 16    | `TIMEOUT_REG`    | Timeout configuration register                 |
| Output    | 16    | `STATUS_REG`     | Status register                                |
| Output    | 32    | `RESP_1_REG`     | Response register                              |
| Output    | 5     | `ERR_INT_REG`    | Error interrupt register                       |
| Output    | 16    | `NORMAL_INT_REG` | Normal interrupt register                      |
| Input     | 1     | `ERR_INT_RST`    | Error interrupt reset signal                   |
| Input     | 1     | `NORMAL_INT_RST` | Normal interrupt reset signal                  |
| Output    | 16    | `settings`       | Command settings output                        |
| Output    | 1     | `go_idle_o`      | Signal to reset the module to idle state       |
| Output    | 40    | `cmd_out`        | Command output to SD/MMC card                  |
| Output    | 1     | `req_out`        | Request signal for service                     |
| Output    | 1     | `ack_out`        | Acknowledge signal for service completion      |
| Input     | 1     | `req_in`         | Request input signal from serial interface     |
| Input     | 1     | `ack_in`         | Acknowledge input signal from serial interface |
| Input     | 40    | `cmd_in`         | Command input from SD/MMC card                 |
| Input     | 8     | `serial_status`  | Serial status input                            |
| Input     | 1     | `card_detect`    | SD card presence detection signal              |

### IO Signal description

The usage of the input and output signals is as following.

The **New_CMD** is asserted when a new command is available in the **ARG_REG.** The both signals **data_write** and **data_read** is set if the incoming command is a block write or block read command. The module read **CMD_SET_REG** and sets up the **settings** signals together with **cmd_out**. Then to initiate a command transfer, the module assert **req_out,** until **ack_in** is received. The **settings** and **cmd_out** is left unchanged during this time. The **req_in**  signal is asserted when valid value on **serial_status** and/or **cmd_in** is present, this is acknowledged with **ack_out.** If a timeout occures the **go_idle_o** signal is asserted.

### Register Definitions

**CMD_SET_REG**

| Bits   | Name          | Description          |
| ------ | ------------- | -------------------- |
| [13:8] | `CMDI`        | Command Index        |
| [7:6]  | `WORD_SELECT` | Word Select          |
| [4]    | `CICE`        | Index Check Enable   |
| [3]    | `CRCE`        | CRC Check Enable     |
| [1:0]  | `RTS`         | Response Type Select |

**STATUS_REG**

| Bits | Name    | Description             |
| ---- | ------- | ----------------------- |
| [0]  | `CICMD` | Reserved for future use |

**ERR_INT_REG**

| Bits | Name    | Description           |
| ---- | ------- | --------------------- |
| [3]  | `CIE`   | Command Index Error   |
| [1]  | `CCRCE` | CRC Error             |
| [0]  | `CTE`   | Command Timeout Error |


**NORMAL_INT_REG**

| Bits | Name | Description      |
| ---- | ---- | ---------------- |
| [15] | `EI` | Error Interrupt  |
| [0]  | `CC` | Command Complete |

**State Definitions**

| State     | Binary Representation | Description                |
| --------- | --------------------- | -------------------------- |
| `IDLE`    | `3'b001`              | Waiting for new command    |
| `SETUP`   | `3'b010`              | Preparing command settings |
| `EXECUTE` | `3'b100`              | Executing the command      |

**Other Defines**

| Bits        | Name      | Description    |
| ----------- | --------- | -------------- |
| `status[6]` | dat_ava   | Data Available |
| `status[5]` | crc_valid | CRC Validity   |

## Functional Blocks

### Debounce Logic

The **Debounce Logic** ensures stable detection of the SD card’s presence by filtering out transient fluctuations or noise in the `card_detect` signal. Mechanical card insertion/removal can cause rapid, unintended toggling of the `card_detect` signal. The debounce mechanism counteracts this by requiring the `card_detect` signal to remain stable for a specific number of consecutive clock cycles before acknowledging a state change.

Conditions：posedge `CLK_PAD_IO ` or posedge `RST_PAD_I   `.

1.**Reset Condition (`RST_PAD_I` High):**

- **Action:** Initialize `debounce` counter and `card_present` flag to `0`.
- **Purpose:** Ensure the system starts in a known, stable state.

2.**Normal Operation (`RST_PAD_I` Low):**

- **Card Detection (`!card_detect`):**
  - **Condition:** If `card_detect` is low (`!card_detect`), indicating the card is present.
  - **Action**: If `debounce` is not yet at its maximum (`4'b1111`), increment `debounce` by `1`. This step verifies that the card detection signal remains low consistently over multiple clock cycles.
  - **Purpose:** Gradually confirm the card's presence to avoid false triggers due to signal noise.
- **Card Not Detected (`card_detect` High):**
  - **Action:** Reset `debounce` counter to `0`.
  - **Purpose:** Immediate dismissal of the card presence if the detection signal is not persistently low.
- **Card Presence Flag (`card_present`):**
  - **Condition:** If `debounce` reaches its maximum value (`4'b1111`), set `card_present` to `1`. Else: Set `card_present` to `0`.
  - **Purpose:** Only assert `card_present` after the debounce counter confirms stability, ensuring reliable card detection.

### Request and Acknowledge Synchronizers

 Synchronize `req_in` and `ack_in` signals across clock domains to prevent metastability. 

Synchronize conditions：posedge `CLK_PAD_IO ` or posedge `RST_PAD_I   `.

The **Acknowledge Signal Synchronization** block mitigates metastability and ensures reliable synchronization of the asynchronous `ack_in` signal to the module’s internal clock domain (`CLK_PAD_IO`). Metastability can occur when an asynchronous signal changes near the clock edge, potentially causing unpredictable behavior.

1. **Reset Condition (`RST_PAD_I` High):**‘

- **Action:** Initialize synchronization registers `ack_q` and `ack_in_int` to `0`.

- **Purpose:** Ensure the acknowledge signal starts in a known, stable state.

2. **Normal Operation (`RST_PAD_I` Low):**

- **First Stage (`ack_q`):** Capture the incoming `ack_in` signal on the rising edge of `CLK_PAD_IO`.

- **Second Stage (`ack_in_int`):** Transfer the synchronized `ack_q` signal to `ack_in_int` on the next rising edge.

- **Purpose:** Two-stage synchronization reduces the probability of metastability by allowing the signal to stabilize before being used internally.

The **Request Signal Synchronization** block serves to safely synchronize the asynchronous `req_in` signal to the internal clock domain. Similar to the acknowledge signal synchronization, this process prevents metastability and ensures that the `req_in` signal is reliably captured within the module.

1. **Reset Condition (`RST_PAD_I` High):**
- **Action:** Initialize synchronization registers `req_q` and `req_in_int` to `0`.
- **Purpose:** Guarantee that the request signal starts in a known, stable state.
2. **Normal Operation (`RST_PAD_I` Low):**
- **First Stage (`req_q`):** Capture the incoming `req_in` signal on the rising edge of `CLK_PAD_IO`.
- **Second Stage (`req_in_int`):** Transfer the synchronized `req_q` signal to `req_in_int` on the next rising edge.
- **Purpose:** Two-stage synchronization ensures the `req_in` signal is free from metastability before being used internally.

### Finite State Machine (FSM)

Combinational logic to determine the next state of the FSM based on current state and inputs.

####  FSM State transitions

**State Transition Table**

The following table outlines the possible state transitions based on current state and input conditions.

| **Current State** | **Input Conditions**                | **Next State** | **Description**                                              |
| ----------------- | ----------------------------------- | -------------- | ------------------------------------------------------------ |
| IDLE              | `New_CMD` asserted                  | SETUP          | A new command is received; transition to SETUP state.        |
| IDLE              | `New_CMD` not asserted              | IDLE           | Remain in IDLE; no new command to process.                   |
| SETUP             | `ack_in_int` asserted               | EXECUTE        | Acknowledge received; move to EXECUTE state.                 |
| SETUP             | `ack_in_int` not asserted           | SETUP          | Remain in SETUP; wait for acknowledgment.                    |
| EXECUTE           | `complete` asserted                 | IDLE           | Command execution completed; return to IDLE state.           |
| EXECUTE           | `complete` not asserted             | EXECUTE        | Continue in EXECUTE; await completion or handle errors.      |
| Default           | Any condition not explicitly listed | IDLE           | Default to IDLE to ensure safe recovery from undefined states. |

**State Diagram**

![FSM_state_transition](./figures/fig1/fig1.png)

#### **State Register Update**

The FSM's current state is updated on each rising edge of the clock (`CLK_PAD_IO`) or reset (`RST_PAD_I`). Upon reset, the state defaults to `IDLE`.

1.**Reset Condition**:

- Sets `state` to `IDLE`.

2.**Normal Operation**:

- Transitions to `next_state` as determined by the combinational logic.

### FSM State operation

The FSM controls various outputs based on the current state and input conditions. The following sections detail the behavior and output assignments in each state.

Conditions：posedge CLK_PAD_IO or posedge RST_PAD_I  

1.**Reset Condition**: RST_PAD_I is high

- Sets `CRC_check_enable`,`complete`,`RESP_1_REG`,`ERR_INT_REG`,`NORMAL_INT_REG`,`STATUS_REG`,`status`,`cmd_out`,`settings`,`response_size`,`req_out`,`index_check_enable`,`ack_out`,`Watchdog_Cnt`,`CCRCE`,`EI`,`CC`,`go_idle_o` to 0.

2.**Normal Operation**: based on the state.

sets NORMAL_INT_REG[1] with card_present, sets NORMAL_INT_REG[2] with ~card_present, sets complete to 0.

- **IDLE State**

  - **Purpose**: 

    Keep checking for status update in the cmd_host module and reseting the go_idle signal

    togheter with the req and ack out signals.

  - **Actions**

    - `go_idle_o`: Set to `0`.
    - `req_out`: Set to `0`.
    - `ack_out`: Set to `0`.
    - `CICMD`: Set to `0`.

    - If `req_in_int` is 1 (indicating a status change from an external module):
      - Update `status` with `serial_status`.
      - Assert `ack_out` to acknowledge the status change.

- **SETUP State**

  - **Purpose**: 

    1.Compose cmd_out by combining command_setting_reg and arg_reg. 

    2.Sets up the settings output vector. 

    3.resets NORMAL_INT_REG, ERR_INT_REG and STATUS_REG

  - **Actions**

    - `NORMAL_INT_REG` and `ERR_INT_REG`: Cleared to `0`.
    - `index_check_enable`: Set based on `CICE` (`CMD_SET_REG[4]`).
    - `CRC_check_enable`: Set based on `CRCE` (`CMD_SET_REG[3]`).
    - Configure `cmd_out` with:
      - Bits `[39:38]`: `2'b01`.
      - Bits `[37:32]`: `CMDI` (`CMD_SET_REG[13:8]`).
      - Bits `[31:0]`: `ARG_REG`.
    - Determine `response_size` based on the `RTS` field:
      - `2'b10` or `2'b11`: Set to `small_rsp` (`7'b0101000`).
      - `2'b01`: Set to `big_rsp` (`7'b1111111`).
      - Otherwise: Set to `0`.
    -     - Configure `settings` with:
      - Bits `[14:13]`: `WORD_SELECT` (`CMD_SET_REG[7:6]`).
      - Bit `12`: `data_read`.
      - Bit `11`: `data_write`.
      - Bits `[10:8]`: `3'b111` (Delay).
      - Bit `7`: `CRCE` (`CMD_SET_REG[3]`).
      - Bits `[6:0]`: `response_size`.
    - `Watchdog_Cnt`: Reset to `0`.
- **EXECUTE State**
  - **Purpose**: 

    1.Increase watchdog counter and check if timeout occur (Watchdog_Cnt>TIMEOUT_REG)

    2.If timeout occur set EI bit ,  CTE bit and go_idle_o to 1 ,and reset the CMD_Host module

    3.Check if the ACK in line is high (CMD_Host is ready) if so request for service.

    4.Check for new serial_status by checking the req_in signal

    5.If new status, check it if status [6] is set, then a command cycle is completed

    6.If set in command_setting check status for valid CRC and performe Index check

    7.Store the data(cmd_in[31:0]) to the RESP_1_REG_, if response_size is >0

  - **Actions**

    - Watchdog Mechanism
      - Increment `Watchdog_Cnt` each cycle.
      - If `Watchdog_Cnt > TIMEOUT_REG`
        - Assert `CTE` (Command Timeout Error) and `EI` (Error Interrupt).
        - If `ack_in` is `1`, set `complete` to `1`.
        - Assert `go_idle_o` to transition back to IDLE.
    - Request and Acknowledge Handling
      - If `ack_in_int` is 1: Start sending when serial module is ready
        - Assert `req_out` to start sending the command.
      - Else if `req_in_int` is 1: Incoming New Status 
        - Update `status` with `serial_status`.
        - Assert `ack_out`.
        - If `dat_ava` is 1
          - Set `complete` to `1` and deassert `EI`.
          - If `CRC_check_enable` is 1 and `crc_valid` is 0: Assert `CCRCE` and `EI`.
          - If `index_check_enable` is 1 and command index mismatch: Assert `CIE` and `EI`.
          - Set `CC` (Command Complete) to `1`.
          - If `response_size` is not `0`, capture response data in `RESP_1_REG`.

#### Data Flow Diagram

**Overall FSM Data Flow**

```
[Next State Logic (FSM_COMBO)]
          |
          v
      [Next State]
          |
          v
     [State Register] ---> Current State
          |
          v
[Output Logic based on Current State]
          |
          v
        Outputs
```

**IDLE State Output Flow**

```
[IDLE State]
     |
     |-- Reset Outputs:
           |--> go_idle_o = 0
           |--> req_out = 0
           |--> ack_out = 0
           |--> CICMD = 0
     |
     |-- Check req_in_int:
           |--> If 1:
                 |--> status = serial_status
                 |--> ack_out = 1
           |--> Else:
                 |--> No action
```

**SETUP State Output Flow**

```
[SETUP State]
     |
     |-- Clear Interrupt Registers:
           |--> NORMAL_INT_REG = 0
           |--> ERR_INT_REG = 0
     |
     |-- Enable Checks:
           |--> index_check_enable = CICE
           |--> CRC_check_enable = CRCE
     |
     |-- Determine response_size:
           |--> If RTS == 2'b10 or 2'b11:
                 |--> response_size = small_rsp
           |--> Else if RTS == 2'b01:
                 |--> response_size = big_rsp
           |--> Else:
                 |--> response_size = 0
     |
     |-- Assemble cmd_out and settings:
           |--> cmd_out[39:38] = 2'b01
           |--> cmd_out[37:32] = CMDI
           |--> cmd_out[31:0] = ARG_REG
           |--> settings[14:13] = WORD_SELECT
           |--> settings[12] = data_read
           |--> settings[11] = data_write
           |--> settings[10:8] = 3'b111
           |--> settings[7] = CRCE
           |--> settings[6:0] = response_size
     |
     |-- Reset Watchdog:
           |--> Watchdog_Cnt = 0
     |
     |-- Assert CICMD:
           |--> CICMD = 1
```

**EXECUTE State Output Flow**

```
[EXECUTE State]
     |
     |-- Increment Watchdog:
           |--> Watchdog_Cnt += 1
     |
     |-- Check Watchdog Timeout:
           |--> If Watchdog_Cnt > TIMEOUT_REG:
                 |--> CTE = 1
                 |--> EI = 1
                 |--> If ack_in == 1:
                       |--> complete = 1
                 |--> go_idle_o = 1
     |
     |-- Control req_out and ack_out:
           |--> If ack_in_int == 1:
                 |--> req_out = 1
           |--> Else if req_in_int == 1:
                 |--> status = serial_status
                 |--> ack_out = 1
                 |--> If dat_ava == 1:
                       |--> complete = 1
                       |--> EI = 0
                       |--> If CRC_check_enable && ~crc_valid:
                             |--> CCRCE = 1
                             |--> EI = 1
                       |--> If index_check_enable && (cmd_out[37:32] != cmd_in[37:32]):
                             |--> CIE = 1
                             |--> EI = 1
                       |--> CC = 1
                       |--> If response_size != 0:
                             |--> RESP_1_REG = cmd_in[31:0]
```

## Clock and Reset

**Clock**

- **Clock Signal**: `CLK_PAD_IO` is the primary clock input for the module. All synchronous operations and state transitions are driven by the rising edge of this clock.

**Reset**

- **Asynchronous Reset**: `RST_PAD_I` is an active-high asynchronous reset signal. When asserted, the module resets all internal registers and states to their default values.

## Corner Cases

**Error Handling**

- **Timeouts**: If a command exceeds the configured `TIMEOUT_REG` value, the module asserts error flags (`CTE`, `EI`) and triggers a transition to the `IDLE` state via `go_idle_o`.
- **CRC Errors**: If CRC checks are enabled and a CRC mismatch is detected, the module sets the `CCRCE` flag and asserts the `EI` interrupt.
- **Index Mismatch**: If an index check is enabled and the received command index does not match the sent index, the module sets the `CIE` flag and asserts the `EI` interrupt.
- **Card Detection Debounce Failure**: Rapid toggling of the `card_detect` signal is handled by the debounce logic to prevent false card presence detection.

**Special Conditions**

- **Simultaneous Interrupt Resets**: Both `ERR_INT_RST` and `NORMAL_INT_RST` can be asserted simultaneously to reset their respective interrupt registers without affecting each other.
- **Status Change During Execution**: The module handles asynchronous status changes from the serial interface by prioritizing ACK signals and updating statuses accordingly.

## Constraints

**Signal Interactions**

- **Mutually Exclusive Signals**: Certain signals are designed to be mutually exclusive to prevent conflicting operations. For example:
  - `data_write` and `data_read` should not be asserted simultaneously as they represent different command types (write vs. read).
  

**Timing Constraints**

- **Debounce Counter**: The debounce counter (`debounce`) must reach its maximum value (`4'b1111`) to confirm card presence. Any fluctuation below this threshold keeps the `card_present` flag inactive.
- **Watchdog Timer**: The watchdog counter (`Watchdog_Cnt`) must not overflow beyond `TIMEOUT_REG` to prevent unintended resets.

**Operational Constraints**

- **CRC and Index Checks**: CRC and index checks are performed only if their respective enable flags (`CRCE`, `CICE`) are set. These checks are essential for ensuring data integrity and command validity.
- **Response Size Determination**: The response size (`response_size`) is determined based on the `RTS` field in `CMD_SET_REG`. Incorrect configuration of `RTS` may lead to unexpected response handling.

**Specific Constraints Based on 2.2.5 Description**

- **Idle State Constraints**:
  - `go_idle_o`, `req_out`, and `ack_out` are deasserted in the `IDLE` state to ensure no unintended command transmissions.
  
- **Setup State Constraints**:
  - `settings` are configured based on the `CMD_SET_REG` inputs, ensuring that only valid commands with proper settings are sent.
  
- **Execute State Constraints**:
  - The module must monitor `complete` and `ack_in_int` to determine when to transition back to `IDLE`.
  - Commands should not be sent if the serial host is busy (`ack_in_int` not asserted).

- **Interrupt Constraints**:
  - Error and normal interrupts should be reset appropriately using `ERR_INT_RST` and `NORMAL_INT_RST` to avoid stale interrupt statuses.

By adhering to these constraints, the `sd_cmd_master` module ensures reliable and predictable interactions with the SD/MMC card, maintaining data integrity and system stability.

