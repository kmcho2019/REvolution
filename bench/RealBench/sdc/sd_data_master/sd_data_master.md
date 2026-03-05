# sd_data_master design specification

Starts to check if there are any new BD thats need to be processed if so the module generate a command by setting up the command and argument register. It then set up the DMA in the FIFO filer to read/write to correct address. If the command line is free the module send the command and wait fore response. If response is valid the module starts the DMA if not valid the CMD is resent again.

During transmission the module keep track for FIFO buffet underflow or overflows, when the transmission is completed it check for valid CRC. If anything goes wrong during a transmission a stop command is sent and the module try to restart the transmission n times before giving up.

## Introduction

### Module Function

The `sd_data_master` module manages data transfer between the SD card and the host system. It performs three primary functions:

1. **Transmit and Receive Data**: It coordinates the transfer of data to and from the SD card by interfacing with the Tx (transmit) and Rx (receive) buffers. It retrieves buffer descriptors for both transmission and reception, managing the flow of data through FIFOs.
   
2. **Execute SD Commands**: The module sends various SD card commands (e.g., CMD17, CMD24, CMD12) for reading, writing, and stopping data transfers. It manages the command sequence, handling responses from the SD card and ensuring proper command execution through retries in case of errors.

3. **Track Transfer Status**: It monitors the status of the data transmission and reception, including error detection (e.g., CRC errors), buffer fullness, and command completion. The module sets status flags to inform the host system of successful transfers or failures, ensuring reliable communication with the SD card.

### Design Overview

The `sd_data_master` module operates as a finite state machine (FSM) with several key states, including `IDLE`, `GET_TX_BD`, `GET_RX_BD`, `SEND_CMD`, `RECIVE_CMD`, and `DATA_TRANSFER`. These states control the progression of data transfers and command execution. The module interfaces with several key control signals and buffers to facilitate data flow, command execution, and status monitoring.

1. **FSM Control**: The module transitions between states based on the availability of data in Tx and Rx buffers, command completion, and error conditions. It handles data transfers in `DATA_TRANSFER` state and executes commands in `SEND_CMD` state.
   
2. **Retry and Error Handling**: The module includes a retry mechanism (`resend_try_cnt`) to handle failed transfers. It tracks command execution through flags like `cmd_busy` and error indicators such as `crc_ok`. Errors trigger transitions to recovery states `STOP_SEND`.

3. **Status Updates**: The module continuously monitors the status of the SD card's data lines, transfer completion, and FIFO buffers. It updates the `Dat_Int_Status` register to notify the host system of the current state, errors, or transfer completions.

## Interface
### Input Ports

| Name            | Width                        | Description                                                      |
|-----------------|------------------------------|------------------------------------------------------------------|
| `clk`           | 1 bit                        | System clock signal                                              |
| `rst`           | 1 bit                        | Reset signal (active high)                                       |
| `dat_in_tx`     | `RAM_MEM_WIDTH-1:0`          | Data in from Tx BD                      |
| `free_tx_bd`    | `BD_WIDTH-1:0`               | Number of Free Tx BD                              |
| `ack_i_s_tx`    | 1 bit                        | ACK in Read request                                 |
| `dat_in_rx`     | `RAM_MEM_WIDTH-1:0`          | Data in from Rx BD                         |
| `free_rx_bd`    | `BD_WIDTH-1:0`               | Number of Free Rx BD                              |
| `ack_i_s_rx`    | 1 bit                        | ACK in Read request                                 |
| `cmd_busy`      | 1 bit                        | CMD Busy state        |
| `we_ack`        | 1 bit                        | Access granted                              |
| `cmd_tsf_err`   | 1 bit                        | Error status of sent cmd                                    |
| `card_status`   | 5 bits                       | Status of card after response                                            |
| `tx_empt`       | 1 bit                        | Tx Fifo empty flag                                |
| `tx_full`       | 1 bit                        | Tx Fifo full flag                                 |
| `rx_full`       | 1 bit                        | Rx Fifo full flag                                 |
| `busy_n`        | 1 bit                        | Data Busy                           |
| `transm_complete` | 1 bit                      | Transmission complete                        |
| `crc_ok`        | 1 bit                        | Crc status                                      |
| `Dat_Int_Status_rst` | 1 bit                   | Reset Dat_Int_Status                             |
| `transfer_type` | 2 bits                       | Indicates the type of data transfer (single block, multiple block, etc.) |

### Output Ports

| Name               | Width           | Description                                                      |
|--------------------|-----------------|------------------------------------------------------------------|
| `re_s_tx`          | 1 bit           | Read Tx BD                                 |
| `a_cmp_tx`         | 1 bit           | Free a Tx BD                                      |
| `re_s_rx`          | 1 bit           | Read Rx BD                                 |
| `a_cmp_rx`         | 1 bit           | Free a Rx BD                                      |
| `we_req`           | 1 bit           | Request access to CMD registers                  |
| `d_write`          | 1 bit           | Block write command                                        |
| `d_read`           | 1 bit           | Block read command                                         |
| `cmd_arg`          | 32 bits         | Cmd argugment out                                 |
| `cmd_set`          | 16 bits         | Cmd setting out                              |
| `start_tx_fifo`    | 1 bit           | Start the Tx Fifo Filler                               |
| `start_rx_fifo`    | 1 bit           | Start the Rx Fifo Filler                               |
| `sys_adr`          | 32 bits         | Memory address for DMA           |
| `ack_transfer`     | 1 bit           | Ack o n transmission complete         |
| `Dat_Int_Status`   | 8 bits          | Se Specification for register details                            |
| `CIDAT`            | 1 bit           | Data inhabit statusbit                                 |

### IO Signal description
The signal **free_xx_bd** is used to keep track on how many free buffer descriptors (BD) there are. To read a BD the signal **re_s_xx** is asserted when **ack_i_s_xx** is received the BD data is read from dat_in_xx. When a data block has been processed the BD is released with **a_cmp_xx** signal set to high.

To send a block write or block read command the first the internal **cmd_arg** and **cmd_set** register is set up. Then the **d_write** or **d_read** is set depending on type of data operation, block read or block write. Then **cmd_busy** is checked so the CMD line is free, if so the **we_req** signal is asserted, an acknowledgment **we_ack** is received when the command has been sent. When the response comes back the **cmd_tsf_err** and **card_status** is checked so the card is in correct state and no errors occurred during transfer.

The signals **start_xx_fifo** is used to start the fifo filler module, **tx_full**, **tx_empty** and **rx_full** is used to keep track on the status of the fifo. The system address the DMA uses is set by the **sys_adr** signal.

When a data block has been transmitted, the **transm_complete** signal asserted, the module resposne with setting **ack_transfer** to 1.

### Internal signals

| Name                     | Type        | Width     | Description                                                                 |
|--------------------------|-------------|-----------|-----------------------------------------------------------------------------|
| `send_done`              | `reg`       | 1 bit     | Indicates if the command sending process is completed                       |
| `rec_done`               | `reg`       | 1 bit     | Indicates if the command receiving process is completed                     |
| `rec_failed`             | `reg`       | 1 bit     | Indicates if the command receiving process failed                           |
| `tx_cycle`               | `reg`       | 1 bit     | Indicates if the module is in Tx mode                                       |
| `rx_cycle`               | `reg`       | 1 bit     | Indicates if the module is in Rx mode                                       |
| `resend_try_cnt`         | `reg`       | 3 bits    | Counter for tracking the number of resend attempts                          |
| `state`                  | `reg`       | 9 bits    | Current state of the FSM                                                    |
| `next_state`             | `reg`       | 9 bits    | Next state of the FSM                                                       |
| `trans_done`             | `reg`       | 1 bit     | Indicates if the data transfer is completed                                 |
| `trans_failed`           | `reg`       | 1 bit     | Indicates if the data transfer failed                                       |
| `internal_transm_complete`| `reg`       | 1 bit     | Internal signal indicating transmission is complete                         |
| `transm_complete_q`      | `reg`       | 1 bit     | Delayed version of the transmission complete signal                         |
| `bd_cnt`                 | `reg`       | 2 or 3 bits| Counter for tracking the buffer descriptor (BD) cycle count                 |
| `sys_adr`                | `reg`       | 32 bits   | Holds the system address for the current transaction                        |
| `cmd_arg`                | `reg`       | 32 bits   | Command argument for the current transaction                                |
| `cmd_set`                | `reg`       | 16 bits   | Command setup value for the current transaction                             |
| `CIDAT`                  | `reg`       | 1 bit     | Internal signal for CRC Interrupt Data status                               |
| `Dat_Int_Status`         | `reg`       | 8 bits    | Internal status register for data interrupts                                |

### Parameters


| Name   | Type   | Width | Value  | Description                                          |
|------------|------------|-----------|------------|----------------------------------------------------------|
| `CMD24`    | Parameter  | 16 bits   | 16'h181A   | Command to write a single block to the SD card.           |
| `CMD17`    | Parameter  | 16 bits   | 16'h111A   | Command to read a single block from the SD card.          |
| `CMD12`    | Parameter  | 16 bits   | 16'hC1A    | Command to stop a transmission on the SD card.            |
| `ACMD13`   | Parameter  | 16 bits   | 16'hD1A    | Command to retrieve SD card status.                       |
| `ACMD51`   | Parameter  | 16 bits   | 16'h331A   | Command to read the SCR register from the SD card.        |
| `SIZE`     | Parameter  | 9 bits    | 9          | Defines the width of the state register in the FSM.       |
| `IDLE`     | Parameter  | 9 bits    | 9'b000000001 | Represents the IDLE state in the FSM.                    |
| `GET_TX_BD`| Parameter  | 9 bits    | 9'b000000010 | Represents the state where the transmit buffer descriptor is obtained. |
| `GET_RX_BD`| Parameter  | 9 bits    | 9'b000000100 | Represents the state where the receive buffer descriptor is obtained. |
| `SEND_CMD` | Parameter  | 9 bits    | 9'b000001000 | Represents the state where a command is sent.            |
| `RECIVE_CMD`| Parameter | 9 bits    | 9'b000010000 | Represents the state where the system waits for a response to the command. |
| `DATA_TRANSFER` | Parameter | 9 bits | 9'b000100000 | Represents the state where data is transferred.          |
| `STOP`     | Parameter  | 9 bits    | 9'b001000000 | Represents the state where the system stops a transmission. |
| `STOP_SEND` | Parameter  | 9 bits   | 9'b010000000 | Represents the state where the stop command is sent.      |
| `RESEND_MAX_CNT` | Parameter | 3 bits | 3          | Defines the maximum number of retries for command sending. |
| `READ_CYCLE` | Parameter | -        | 2 or 4     | Defines the number of read cycles based on memory width.  |
| `BD_EMPTY`  | Parameter | -        | Derived from BD_SIZE | Indicates an empty buffer descriptor (Tx or Rx).       |


### External Signals

| Name                  | Width                                  | Description                                                                                     |
|-----------------------|----------------------------------------|-------------------------------------------------------------------------------------------------|
| `RAM_MEM_WIDTH`        | Defined in external file               | Defines the width of RAM memory, can be 16 bits or 32 bits, affects read cycle and buffer descriptor behavior. |
| `BD_WIDTH`             | Defined in external file               | Defines the width of the buffer descriptor.                                                      |
| `BD_SIZE`              | Defined in external file               | Defines the size of the buffer descriptor.                                                       |

#### Definitions Related to External Variables
- **`RESEND_MAX_CNT`** is defined as 3, which indicates the maximum number of retries for sending a command.
- The `READ_CYCLE` value depends on the RAM memory width:
  - If the RAM memory width is 32 bits (`RAM_MEM_WIDTH_32` is defined), then `READ_CYCLE` is set to 2, and a 2-bit register `bd_cnt` is declared.
  - If the RAM memory width is 16 bits (`RAM_MEM_WIDTH_16` is defined), then `READ_CYCLE` is set to 4, and a 3-bit register `bd_cnt` is declared.
- The value of **`BD_EMPTY`** is also determined by the memory width:
  - For 32-bit RAM, `BD_EMPTY` is set to half of `BD_SIZE` (i.e., `BD_SIZE / 2`).
  - For 16-bit RAM, `BD_EMPTY` is set to one-quarter of `BD_SIZE` (i.e., `BD_SIZE / 4`).
## Finite State Machine(FSM)

![](./figures/sd_data_master/sd_data_master.drawio.png)
### State Transition Table
| Current State      | Input Conditions                                                                                  | Next State         | Description                                                                                          |
|--------------------|--------------------------------------------------------------------------------------------------|--------------------|------------------------------------------------------------------------------------------------------|
| `IDLE`             | `free_tx_bd != BD_EMPTY`                                              | `GET_TX_BD` | Checks if there are available buffer descriptors (Tx BD) to start transmission.        |
| `IDLE`             | `free_rx_bd != BD_EMPTY`                                              | `GET_RX_BD` | Checks if there are available buffer descriptors (Rx BD) to start reception.        |
| `IDLE`             | otherwise                                                                                         | `IDLE`             | Remains in `IDLE` state when no buffer descriptors are available.                                     |
| `GET_TX_BD`        | `bd_cnt > READ_CYCLE - 1` and `tx_full == 1`                                                      | `SEND_CMD`         | Successfully retrieves the transmit buffer descriptor (Tx BD) and prepares for sending a command.      |
| `GET_TX_BD`        | otherwise                                                     | `GET_TX_BD`        | Continues fetching Tx BD if conditions are not met (buffer descriptor count is low or Tx buffer not full). |
| `GET_RX_BD`        | `bd_cnt >= READ_CYCLE - 1`                                                                        | `SEND_CMD`         | Successfully retrieves the receive buffer descriptor (Rx BD) and prepares for sending a command.       |
| `GET_RX_BD`        | otherwise                                                                       | `GET_RX_BD`        | Continues fetching Rx BD if the buffer descriptor count is insufficient.                              |
| `SEND_CMD`         | `send_done == 1`                                                                                  | `RECIVE_CMD`       | Sends the command successfully and transitions to receive command state.                              |
| `SEND_CMD`         | otherwise                                                                                         | `SEND_CMD`         | Continues sending the command if not complete.                                                        |
| `RECIVE_CMD`       | `rec_done == 1`                                                                                   | `DATA_TRANSFER`    | Successfully receives the command and moves to data transfer state.                                   |
| `RECIVE_CMD`       | `rec_failed == 1`                                                                                 | `SEND_CMD`         | If command reception fails, retries by sending the command again.                                     |
| `RECIVE_CMD`       | otherwise                                                                                         | `RECIVE_CMD`       | Continues receiving the command until success or failure.                                             |
| `DATA_TRANSFER`    | `trans_done == 1`                                                                                 | `IDLE`             | Successfully completes data transfer and returns to `IDLE`.                                           |
| `DATA_TRANSFER`    | `trans_failed == 1`                                                                               | `STOP`             | If data transfer fails, transitions to `STOP` state to terminate the process.                         |
| `DATA_TRANSFER`    | otherwise                                                                                         | `DATA_TRANSFER`    | Continues the data transfer if it's not yet completed or failed.                                      |
| `STOP`             | N/A                                                                                               | `STOP_SEND`        | Prepares to send a stop command to halt data transmission.                                            |
| `STOP_SEND`        | `send_done == 1`                                                                                  | `IDLE`             | Successfully sends the stop command and transitions back to `IDLE`.                                   |
| `STOP_SEND`        | otherwise                                                                                         | `STOP_SEND`        | Continues sending the stop command until successful.                                                  |

### state descriptions

1. **IDLE**: The idle state, where the system checks if there are available transmit or receive buffer descriptors (Tx/Rx BD).
2. **GET_TX_BD**: Retrieves the transmit buffer descriptor (Tx BD) to prepare for sending a data command.
3. **GET_RX_BD**: Retrieves the receive buffer descriptor (Rx BD) to prepare for receiving a data command.
4. **SEND_CMD**: Sends a command to the physical interface, entering the process of sending data or receiving a command.
5. **RECIVE_CMD**: Waits for a command response from the physical interface.
6. **DATA_TRANSFER**: Executes the actual data transfer operation.
7. **STOP**: Stops the current transmission process and prepares to send a stop command.
8. **STOP_SEND**: Sends the stop command to ensure the data transfer is correctly terminated.

### State Self-loop Transitions:
- Each state includes a transition back to itself (e.g., when sending or receiving is incomplete) to ensure the module correctly handles intermediate states and transitions according to input conditions.

### FSM_SEQ

**Reset Condition (`rst` High)**:

- The FSM state is set to `IDLE`, regardless of the current state.
- Ensures the FSM starts in a known, stable state upon reset.

**Normal Operation (`rst` Low)**:

- On each rising edge of `clk`, the current state state transitions to next_state.
- next_state is determined by the combinational logic in the FSM_COMBO block.

### FSM_OUT

**Reset Condition (`rst` High)**:

  Reset all control signals 

**Normal Operation (`rst` Low)**:

Here is the conversion of the state machine code into the specified format:

1. **IDLE State**

    Reset all control signals 

2. **GET_TX_BD State**
   1. Assert `re_s_tx = 1` to read a transmit buffer descriptor
   2. Process data based on memory width:
      - For 32-bit RAM:
        - First read: Store data to `sys_adr`
        - Second read: Store data to `cmd_arg` and start TX FIFO
      - For 16-bit RAM:
        - Four reads to populate `sys_adr` and `cmd_arg` (16 bits at a time)
        - After last read, start TX FIFO
   3. Set `cmd_set = CMD24` (write single block command)
   4. Set `tx_cycle = 1` to indicate transmit mode

3. **GET_RX_BD State**
   1. Assert `re_s_rx = 1` to read a receive buffer descriptor
   2. Process data based on memory width:
      - For 32-bit RAM:
        - First read: Store data to `sys_adr`
        - Second read: Store data to `cmd_arg`
      - For 16-bit RAM:
        - Four reads to populate `sys_adr` and `cmd_arg` (16 bits at a time)
   3. Set command based on `transfer_type`:
      - If 2'b00: Set `cmd_set = CMD17` (read single block)
      - If 2'b01: Set `cmd_set = ACMD13` (SD status)
      - Otherwise: Set `cmd_set = ACMD51` (SCR register)
   4. Set `rx_cycle = 1` to indicate receive mode

4. **SEND_CMD State**
    1. Check type of cycle rx or tx
    2. Set d_read or d_write acordely
    3. Check if CMD is free, if so assert we_req
    4. Wait for we_ack
    5. Set send_done to 1 .

5. **RECEIVE_CMD State**
    1. Start Rx_Fifo_Filer if Rx cycle
    2. Wait for command response (indicated by cmd_busy are low)
    3. Check so cmd_tsf_err is not asserted, if asserted set command_failed.
    4. Check the response data, 
    5. If card is ready for data card_status[0] == 1
    6. If card is in transmission state for data card_status[4:1] == 4,5 or 6

6. **DATA_TRANSFER State**
    1. If tx_cycle check so tx_fifo doenst get empty 
    2. If rx_cycle check so rx_fifo doenst get full 
    3. Wait for command complete
    4. Check so crc_ok == 1 
    5. Free the BD

7. **STOP State**
     1. Set `cmd_set` to `CMD12`
     2. Set `rec_done`, `rec_failed`, `send_done`, `trans_failed`, `trans_done` to `0`
     3. Set `d_read`, `d_write` to `1`
     4. Set `start_rx_fifo`, `start_tx_fifo` to `0`

8. **STOP_SEND State**
      1. Increment `resend_try_cnt` by `1`
      2. If `resend_try_cnt` reachs `RESEND_MAX_CNT`, then set `Dat_Int_Status[1]` to `1`
      3. If CMD is not busy, then request access to CMD registers
      4. If sccess granted(`we_ack == 1`), then message has send done.

9. **STOP_RECEIVE_CMD State**
    NOT request access to CMD registers

10. if `Dat_Int_Status_rst`, set `Dat_Int_Status` to `0`.

## Clock and Reset

### Clock
Clock Signal: `clk` is the primary clock input for the module. All synchronous operations and state transitions are driven by the rising edge of this clock.

### Reset
Asynchronous Reset: `rst` is an active-high asynchronous reset signal. When asserted, the module resets all internal registers and states to their default values.

## Constraints 

### 1. **Clock and Reset Constraints**
   - The state machine operates on a clock signal (`clk`).
   - The system should respond to a reset signal (`rst`), initializing the state machine and all relevant output variables to their default values.

### 2. **State Transition Constraints**
   - The state transitions depend on the current state and various input signals.
   - Only one state can be active at any given time.
   - The state machine must ensure that transitions happen only at the rising edge of the clock or during a reset.

### 3. **Input Acknowledgment Constraints**
   - In states like `GET_RX_BD` and `GET_TX_BD`, the machine must wait for acknowledgment signals (`ack_i_s_rx`, `ack_i_s_tx`) before proceeding with data handling.
   - If the acknowledgment is not received, the state machine may not be able to proceed, preventing data corruption.

### 4. **Data Handling Constraints**
   - The input data signals (`DAT_dat_i`) must be stable before they are read, particularly during the `WRITE_CRC`, `GET_RX_BD`, and `GET_TX_BD` states.
   - The data output signals (e.g., `d_read`, `d_write`) must be controlled to ensure that the correct data flow occurs at the right times.

### 5. **Block Count Constraints**
   - The `bd_cnt` variable is used to track the number of blocks being processed. It should only increment within its defined bounds to prevent overflow or underflow.
   - The maximum count for `bd_cnt` should be constrained to prevent exceeding the expected data structure size.

### 6. **Command Set Constraints**
   - The command set (`cmd_set`) must be correctly assigned based on the type of data transfer. Commands must adhere to predefined conditions for proper functioning.

### 7. **Transfer Constraints**
   - Conditions must be checked to ensure that data transfers only occur when the system is ready (e.g., `cmd_busy` must be `0` before sending commands).
   - Constraints related to the status of the card (`card_status`) must be evaluated to determine the success or failure of data transfers.

### 8. **Failure and Acknowledgment Constraints**
   - The system should properly handle failure conditions (e.g., `trans_failed`, `rec_failed`) and provide corresponding status updates through the `Dat_Int_Status` register.
   - Acknowledgments for commands (`we_ack`) must be monitored to ensure that operations have completed successfully.

### 9. **Data Integrity Constraints**
   - The data integrity during transfers must be ensured, particularly through checks on the CRC (cyclic redundancy check) status.
   - Any CRC errors or issues must trigger the appropriate status signals to prevent the use of corrupted data.

### 10. **Resend Mechanism Constraints**
   - The resend mechanism (`resend_try_cnt`) should be limited to a predefined maximum (`RESEND_MAX_CNT`) to avoid endless retries, ensuring that the system can recover gracefully from transmission errors.

These constraints ensure that the state machine operates reliably, handling data correctly, responding to inputs appropriately, and managing transitions between states without errors.