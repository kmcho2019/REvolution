# e203_exu_alu_lsuagu.v Specification

This module is used to implement the **AGU** (Address Generation Unit) for **load/store** and **atomic memory operations (AMO)** instructions. The AGU shares most of its datapath with the ALU module to minimize gate count and optimize area usage.

---

## Introduction

The AGU is responsible for generating memory addresses for load/store and AMO instructions. It supports the following features:
1. Address computation for aligned and unaligned memory accesses.
2. Atomic operations like AMOSWAP, AMOADD, AMOAND, AMOOR, AMOXOR, AMOMAX, AMOMIN, AMOMAXU, and AMOMINU.
3. Exception handling for misaligned memory accesses and bus errors.
4. Interface with the LSU (Load/Store Unit) for memory transactions.
5. Sharing the ALU datapath for efficient address calculation and AMO operations.

---

## Module Diagram

![module_diagram](figures/e203_exu_alu_lsuagu_module_diagram.png)

---

## Interface

| Direction | Port Name            | Width                  | Description                                                                 |
| --------- | -------------------- | ---------------------- | --------------------------------------------------------------------------- |
| **Input** | `agu_i_valid`        | 1                      | Valid signal for AGU operation.                                             |
| **Output**| `agu_i_ready`        | 1                      | Ready signal for AGU operation.                                             |
| **Input** | `agu_i_rs1`          | `E203_XLEN`            | Source register 1 (base address for memory access).                         |
| **Input** | `agu_i_rs2`          | `E203_XLEN`            | Source register 2 (used in AMO or store operations).                        |
| **Input** | `agu_i_imm`          | `E203_XLEN`            | Immediate value for address generation.                                     |
| **Input** | `agu_i_info`         | `E203_DECINFO_AGU_WIDTH` | Instruction information for decoding and control.                          |
| **Input** | `agu_i_itag`         | `E203_ITAG_WIDTH`      | Instruction tag for tracking outstanding memory operations.                 |
| **Output**| `agu_i_longpipe`     | 1                      | Indicates if the operation is a long pipeline instruction.                  |
| **Input** | `flush_req`          | 1                      | Flush request signal.                                                       |
| **Input** | `flush_pulse`        | 1                      | Flush pulse signal.                                                         |
| **Output**| `amo_wait`           | 1                      | Indicates if the AMO operation is waiting for completion.                   |
| **Input** | `oitf_empty`         | 1                      | Indicates if the Outstanding Instruction Tracking FIFO (OITF) is empty.     |
| **Output**| `agu_o_valid`        | 1                      | Valid signal for write-back/commit interface.                               |
| **Input** | `agu_o_ready`        | 1                      | Ready signal for write-back/commit interface.                               |
| **Output**| `agu_o_wbck_wdat`    | `E203_XLEN`            | Write-back data for load or AMO operations.                                 |
| **Output**| `agu_o_wbck_err`     | 1                      | Error signal for write-back operations.                                     |
| **Output**| `agu_o_cmt_misalgn`  | 1                      | Misalignment exception indicator.                                           |
| **Output**| `agu_o_cmt_ld`       | 1                      | Load instruction commit signal.                                             |
| **Output**| `agu_o_cmt_stamo`    | 1                      | Store or AMO instruction commit signal.                                     |
| **Output**| `agu_o_cmt_buserr`   | 1                      | Bus error exception indicator.                                              |
| **Output**| `agu_o_cmt_badaddr`  | `E203_ADDR_SIZE`       | Address causing the misalignment or bus error.                              |
| **Output**| `agu_icb_cmd_valid`  | 1                      | Valid signal for LSU ICB command interface.                                 |
| **Input** | `agu_icb_cmd_ready`  | 1                      | Ready signal for LSU ICB command interface.                                 |
| **Output**| `agu_icb_cmd_addr`   | `E203_ADDR_SIZE`       | Address for LSU memory transactions.                                        |
| **Output**| `agu_icb_cmd_read`   | 1                      | Read/write control signal for LSU transactions.                             |
| **Output**| `agu_icb_cmd_wdata`  | `E203_XLEN`            | Write data for LSU transactions (store/AMO).                                |
| **Output**| `agu_icb_cmd_wmask`  | `E203_XLEN/8`          | Write mask for LSU transactions (byte-level granularity).                   |
| **Output**| `agu_icb_cmd_back2agu` | 1                   | Indicates if the response should return to AGU.                             |
| **Output**| `agu_icb_cmd_lock`   | 1                      | Lock signal for LSU transactions (not used in this implementation).         |
| **Output**| `agu_icb_cmd_excl`   | 1                      | Exclusive access signal for LSU transactions (e.g., AMO).                   |
| **Output**| `agu_icb_cmd_size`   | 2                      | Size of the memory access (byte, halfword, word).                           |
| **Output**| `agu_icb_cmd_itag`   | `E203_ITAG_WIDTH`      | Instruction tag for the LSU transaction.                                    |
| **Output**| `agu_icb_cmd_usign`  | 1                      | Unsigned access indicator.                                                  |
| **Input** | `agu_icb_rsp_valid`  | 1                      | Valid signal for LSU response interface.                                    |
| **Output**| `agu_icb_rsp_ready`  | 1                      | Ready signal for LSU response interface.                                    |
| **Input** | `agu_icb_rsp_err`    | 1                      | Error signal for LSU responses.                                             |
| **Input** | `agu_icb_rsp_excl_ok` | 1                     | Exclusive access success indicator.                                         |
| **Input** | `agu_icb_rsp_rdata`  | `E203_XLEN`            | Read data from LSU transactions.                                            |
| **Output**| `agu_req_alu_op1`    | `E203_XLEN`            | Operand 1 for ALU (shared datapath).                                        |
| **Output**| `agu_req_alu_op2`    | `E203_XLEN`            | Operand 2 for ALU (shared datapath).                                        |
| **Output**| `agu_req_alu_swap`   | 1                      | Control signal for AMO SWAP operation.                                      |
| **Output**| `agu_req_alu_add`    | 1                      | Control signal for ADD operation (address generation or AMO ADD).           |
| **Output**| `agu_req_alu_and`    | 1                      | Control signal for AND operation (AMO AND).                                 |
| **Output**| `agu_req_alu_or`     | 1                      | Control signal for OR operation (AMO OR).                                   |
| **Output**| `agu_req_alu_xor`    | 1                      | Control signal for XOR operation (AMO XOR).                                 |
| **Output**| `agu_req_alu_max`    | 1                      | Control signal for MAX operation (AMO MAX).                                 |
| **Output**| `agu_req_alu_min`    | 1                      | Control signal for MIN operation (AMO MIN).                                 |
| **Output**| `agu_req_alu_maxu`   | 1                      | Control signal for MAXU operation (unsigned AMO MAX).                       |
| **Output**| `agu_req_alu_minu`   | 1                      | Control signal for MINU operation (unsigned AMO MIN).                       |
| **Input** | `agu_req_alu_res`    | `E203_XLEN`            | ALU result (shared datapath).                                               |
| **Output**| `agu_sbf_0_ena`      | 1                      | Enable signal for shared buffer 0.                                          |
| **Output**| `agu_sbf_0_nxt`      | `E203_XLEN`            | Next value for shared buffer 0.                                             |
| **Input** | `agu_sbf_0_r`        | `E203_XLEN`            | Current value of shared buffer 0.                                           |
| **Output**| `agu_sbf_1_ena`      | 1                      | Enable signal for shared buffer 1.                                          |
| **Output**| `agu_sbf_1_nxt`      | `E203_XLEN`            | Next value for shared buffer 1.                                             |
| **Input** | `agu_sbf_1_r`        | `E203_XLEN`            | Current value of shared buffer 1.                                           |
| **Input** | `clk`                | 1                      | Clock signal.                                                               |
| **Input** | `rst_n`              | 1                      | Active-low reset signal.                                                    |

---

## Submodule List

- `sirv_gnrl_dfflr`: General-purpose D flip-flop with load and reset, used for various state registers like `icb_state`, `unalgn_flg`, and `leftover` buffers.

### Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |

---

## Function Description

1. **Address Generation**:
   - Computes memory addresses for load, store, and AMO instructions.
2. **AMO Operations**:
   - Supports atomic instructions (e.g., AMOADD, AMOAND, AMOSWAP).
   - Manages multi-cycle AMO operations with state transitions.
3. **Exception Handling**:
   - Detects misaligned memory accesses and raises exceptions.
   - Detects bus errors during memory transactions.
4. **Integration with LSU**:
   - Interfaces with the Load/Store Unit (LSU) using an ICB (Internal Circuit Bus) protocol for memory transactions.

---

## AGU Info Bus

| Bit field | Signal name | Description |
| :--------------------------- | :---------------- | :------------------------------------------------------- |
| [`E203_DECINFO_AGU_LOAD`] | `agu_i_load` | Load operation flag (1: current is a load instruction) |
| [`E203_DECINFO_AGU_STORE`] | `agu_i_store` | Store operation flag (1: current is a store instruction) |
| [`E203_DECINFO_AGU_AMO`] | `agu_i_amo` | Atomic operation flag (1: current is an atomic operation instruction) |
| [`E203_DECINFO_AGU_SIZE`] | `agu_i_size[1:0]` | Data size encoding: 00-byte (8bit) 01-halfword (16bit) 10-word (32bit) |
| [`E203_DECINFO_AGU_USIGN`] | `agu_i_usign` | Unsigned extension flag (1: unsigned extension, 0: signed extension) |
| [`E203_DECINFO_AGU_EXCL`] | `agu_i_excl` | Exclusive access flag (1: exclusive memory access operation) |
| [`E203_DECINFO_AGU_AMOSWAP`] | `agu_i_amoswap` | Atomic swap operation flag (SWAP-type atomic operation) |
| [`E203_DECINFO_AGU_AMOADD`] | `agu_i_amoadd` | Atomic addition operation flag (ADD-type atomic operation) |
| [`E203_DECINFO_AGU_AMOAND`] | `agu_i_amoand` | Atomic and operation flag (AND-type atomic operation) |
| [`E203_DECINFO_AGU_AMOOR`] | `agu_i_amoor` | Atomic OR operation identifier (OR type atomic operation) |
| [`E203_DECINFO_AGU_AMOXOR`] | `agu_i_amoxor` | Atomic XOR operation identifier (XOR type atomic operation) |
| [`E203_DECINFO_AGU_AMOMAX`] | `agu_i_amomax` | Signed maximum value atomic operation identifier (MAX type atomic operation) |
| [`E203_DECINFO_AGU_AMOMIN`] | `agu_i_amomin` | Signed minimum value atomic operation identifier (MIN type atomic operation) |
| [`E203_DECINFO_AGU_AMOMAXU`] | `agu_i_amomaxu` | Unsigned maximum value atomic operation identifier (MAXU type atomic operation) |
| [`E203_DECINFO_AGU_AMOMINU`] | `agu_i_amominu` | Unsigned minimum atomic operation identifier (MINU-type atomic operation) |

## Implementation Details

### State Machine:

State Definition

The AMO operation state machine defines the following 7 states:

| State | Encoding | Description |
| ------------------- | ---- | ------------------------------------------- |
| `ICB_STATE_IDLE` | 4'd0 | Idle state, no outstanding requests |
| `ICB_STATE_1ST` | 4'd1 | First request (read) has been issued and waiting for response |
| `ICB_STATE_AMOALU` | 4'd4 | Read data has been placed in the buffer, ready for ALU calculation |
| `ICB_STATE_AMORDY` | 4'd5 | ALU has calculated a new result and placed it in the buffer |
| `ICB_STATE_WAIT2ND` | 4'd2 | Waiting to issue the second request (write) |
| `ICB_STATE_2ND` | 4'd3 | Second request has been issued and waiting for response |
| `ICB_STATE_WBCK` | 4'd6 | Response data has been returned, ready to write the result back to the commit/writeback interface |

### State transfer conditions

**IDLE → 1ST**:

- Condition: `state_idle_exit_ena = icb_sta_is_idle & state_idle_to_exit & agu_icb_cmd_hsked & (~flush_pulse)`


- Where `state_idle_to_exit = agu_i_algnamo & oitf_empty`


- Function: Start AMO operation and send read request

**1ST → AMOALU**:

- Condition: `state_1st_exit_ena = icb_sta_is_1st & (agu_icb_rsp_hsked | flush_pulse)`

- Function: Read response reception is completed, ready for ALU operation

**AMOALU → AMORDY**:

- Condition: `state_amoalu_exit_ena = icb_sta_is_amoalu & (1'b1 | flush_pulse)`
- Effect: ALU calculation completed

**AMORDY → WAIT2ND**:

- Condition: `state_amordy_exit_ena = icb_sta_is_amordy & (1'b1 | flush_pulse)`
- Effect: Prepare to send write-back request

**WAIT2ND → 2ND**:

- Condition: `state_wait2nd_exit_ena = icb_sta_is_wait2nd & (agu_icb_cmd_ready | flush_pulse)`
- Effect: Bus is ready to receive write request

**2ND → WBCK**:

- Condition: `state_2nd_exit_ena = icb_sta_is_2nd & (agu_icb_rsp_hsked | flush_pulse)`
- Function: Write response reception completed, ready to write result back to CPU core

**WBCK → IDLE**:

- Condition: `state_wbck_exit_ena = icb_sta_is_wbck & (agu_o_ready | flush_pulse)`
- Function: Write back completed, end AMO operation

### Refresh mechanism

The state machine design includes the processing of refresh request (`flush_pulse` and `flush_req`):

1. When `flush_pulse` is valid, the state machine will jump back to IDLE state and terminate the current AMO operation
2. `flush_block = flush_req & icb_sta_is_idle` signal is used to block new instruction recognition to prevent new operation from being started during refresh

3. **Leftover Buffer**: 
   - Stores intermediate results for AMO and MULDIV(optional) operations.


3. **ICB Interface**: 
   - Handles LSU transactions for both aligned and unaligned memory accesses.


4. **Write-Back Interface**: 
   - Passes results from the AGU to the commit stage.

---

## Clock and Reset

- **Clock (`clk`)**: Drives the sequential logic.
- **Reset (`rst_n`)**: Active-low reset initializes all state registers and buffers.

---

## Constraints

- The module relies on the proper configuration of `E203_SUPPORT_AMO` and `E203_SUPPORT_UNALGNLDST` macros for enabling/disabling AMO and unaligned load/store support.
- Misalignment exceptions are raised if unaligned load/store is not supported by hardware.