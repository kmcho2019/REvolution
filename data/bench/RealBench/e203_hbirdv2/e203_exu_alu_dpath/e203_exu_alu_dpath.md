# e203_exu_alu_dpath Design Specification

## Introduction

The `e203_exu_alu_dpath` module is the datapath implementation of the Arithmetic Logic Unit (ALU) in the E203 processor. This module is responsible for executing arithmetic, logic, shift, comparison, and other operations requested by various execution units, such as the `e203_exu_alu_rglr`, `e203_exu_alu_csrctrl`, `e203_exu_alu_lsuagu`, and optionally the `e203_exu_alu_muldiv`. It is designed to be efficient, highly reusable, and supports multiple functional units through shared resources.

## Module Diagram

Below is a high-level functional block diagram of the module:

![module_diagram](figures/e203_exu_alu_dpath_module_diagram2.png)

## Interface

**Basic Inputs**

| Signal Name           | Width       | Description                                                  |
| --------------------- | ----------- | ------------------------------------------------------------ |
| `alu_req_alu`         | 1           | Request signal for ALU operations                            |
| `alu_req_alu_add`     | 1           | Indicates `ADD` operation is requested                       |
| `alu_req_alu_sub`     | 1           | Indicates `SUB` operation is requested                       |
| `alu_req_alu_xor`     | 1           | Indicates `XOR` operation is requested                       |
| `alu_req_alu_sll`     | 1           | Indicates `Shift Left Logical (SLL)` operation               |
| `alu_req_alu_srl`     | 1           | Indicates `Shift Right Logical (SRL)` operation              |
| `alu_req_alu_sra`     | 1           | Indicates `Shift Right Arithmetic (SRA)` operation           |
| `alu_req_alu_or`      | 1           | Indicates `OR` operation is requested                        |
| `alu_req_alu_and`     | 1           | Indicates `AND` operation is requested                       |
| `alu_req_alu_slt`     | 1           | Indicates `Set Less Than` operation is requested             |
| `alu_req_alu_sltu`    | 1           | Indicates `Set Less Than Unsigned` operation is requested    |
| `alu_req_alu_lui`     | 1           | Indicates `Load Upper Immediate` operation is requested      |
| `alu_req_alu_op1`     | `E203_XLEN` | Operand 1 for ALU operations                                 |
| `alu_req_alu_op2`     | `E203_XLEN` | Operand 2 for ALU operations                                 |
| `bjp_req_alu`         | 1           | Indicates that there is a calculation request from the bjp unit |
| `bjp_req_alu_op1`     | `E203_XLEN` | Operand 1 for BJP operations                                 |
| `bjp_req_alu_op2`     | `E203_XLEN` | Operand 2 for BJP operations                                 |
| `bjp_req_alu_cmp_eq`  | 1           | Indicates `Equal` comparison operation is requested          |
| `bjp_req_alu_cmp_ne`  | 1           | Indicates `Not Equal` comparison operation is requested      |
| `bjp_req_alu_cmp_lt`  | 1           | Indicates `Less Than` comparison operation is requested      |
| `bjp_req_alu_cmp_gt`  | 1           | Indicates `Greater Than` comparison operation is requested   |
| `bjp_req_alu_cmp_ltu` | 1           | Indicates `Less Than Unsigned` comparison operation is requested |
| `bjp_req_alu_cmp_gtu` | 1           | Indicates `Greater Than Unsigned` comparison operation is requested |
| `bjp_req_alu_add`     | 1           | Indicates `ADD` operation is requested for BJP calculations  |
| `agu_req_alu`         | 1           | Indicates that there is a calculation request from the agu unit |
| `agu_req_alu_op1`     | `E203_XLEN` | Operand 1 for AGU operations                                 |
| `agu_req_alu_op2`     | `E203_XLEN` | Operand 2 for AGU operations                                 |
| `agu_req_alu_swap`    | 1           | Indicates `SWAP` operation is requested                      |
| `agu_req_alu_add`     | 1           | Indicates `ADD` operation is requested                       |
| `agu_req_alu_and`     | 1           | Indicates `AND` operation is requested                       |
| `agu_req_alu_or`      | 1           | Indicates `OR` operation is requested                        |
| `agu_req_alu_xor`     | 1           | Indicates `XOR` operation is requested                       |
| `agu_req_alu_max`     | 1           | Indicates `MAX` (signed maximum) operation is requested      |
| `agu_req_alu_min`     | 1           | Indicates `MIN` (signed minimum) operation is requested      |
| `agu_req_alu_maxu`    | 1           | Indicates `MAXU` (unsigned maximum) operation is requested   |
| `agu_req_alu_minu`    | 1           | Indicates `MINU` (unsigned minimum) operation is requested   |
| `agu_sbf_0_ena`       | 1           | Enable signal for AGU scoreboard buffer 0                    |
| `agu_sbf_0_nxt`       | E203_XLEN   | Next value for AGU scoreboard buffer 0                       |
| `agu_sbf_1_ena`       | 1           | Enable signal for AGU scoreboard buffer 1                    |
| `agu_sbf_1_nxt`       | E203_XLEN   | Next value for AGU scoreboard buffer 1                       |
| `clk`                 | 1           | Clock signal                                                 |
| `rst_n`               | 1           | Active-low reset signal                                      |

**Basic Outputs**

| Signal Name           | Width       | Description                              |
| --------------------- | ----------- | ---------------------------------------- |
| `alu_req_alu_res`     | `E203_XLEN` | Result of ALU operations.                |
| `bjp_req_alu_add_res` | `E203_XLEN` | Result of BJP addition operation.        |
| `bjp_req_alu_cmp_res` | 1           | Result of BJP comparison (equal or not). |
| `agu_req_alu_res`     | `E203_XLEN` | Result of AGU operations.                |

**Optional Interface**

These interfaces are available if `E203_SUPPORT_SHARE_MULDIV` is defined

| Direction | Signal Name          | Width                  | Description                                                  |
| --------- | -------------------- | ---------------------- | ------------------------------------------------------------ |
| Input     | `muldiv_req_alu`     | 1                      | Indicates that there is a calculation request from the muldiv unit |
| Input     | `muldiv_req_alu_op1` | `E203_ALU_ADDER_WIDTH` | Operand 1 for MULDIV operations                              |
| Input     | `muldiv_req_alu_op2` | `E203_ALU_ADDER_WIDTH` | Operand 2 for MULDIV operations                              |
| Input     | `muldiv_req_alu_add` | 1                      | Indicates that the muldiv unit requests an addition operation |
| Input     | `muldiv_req_alu_sub` | 1                      | Indicates that the muldiv unit requests an subtraction operation |
| Input     | `muldiv_sbf_0_ena`   | 1                      | Shared buffer 0 enable signal                                |
| Input     | `muldiv_sbf_0_nxt`   | 33                     | The value to be stored in shared buffer 0                    |
| Input     | `muldiv_sbf_1_ena`   | 1                      | Shared buffer 1 enable signal                                |
| Input     | `muldiv_sbf_1_nxt`   | 33                     | The value to be stored in shared buffer 1                    |
| Output    | `muldiv_req_alu_res` | `E203_ALU_ADDER_WIDTH` | Result of MULDIV operations.                                 |
| Output    | `muldiv_sbf_0_r`     | 33                     | Current value of shared buffer 0                             |
| Output    | `muldiv_sbf_1_r`     | 33                     | Current value of shared buffer 1                             |



---

## Submodule List

### sirv_gnrl_dffl

#### Parameter Configuration

| Parameter Name | Value | Description          |
| -------------- | ----- | -------------------- |
| DW             | 33    | Data width (in bits) |

#### Signal Interface

| Port Name | Direction | Width | Description        |
| --------- | --------- | ----- | ------------------ |
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data         |
| qout      | Output    | DW    | Output data        |
| clk       | Input     | 1     | Clock signal       |

1. sbf_0_dffl
1. svf_1_dffl

## Function Description

### ALU Request Handling

- Arithmetic Operations: add,sub
- Logical Operations: xor,or,and
- Shift Operations: sll,srl,sra
- Other Operations: slt,sltu,lui

### BJP Request Handling

- Comparison Operations: beq,bne,blt,bgt,bltu,bgtu
- Addition for branch offset calculations

### AGU Request Handling

AGU calculation requests are only generated when the implementation supports atomic memory operations (AMO). The operations that need to be supported are:

- Arithmetic and logical operations: add, and, or, xor
- Maximum and minimum calculations: max, min, maxu, minu
- swap

Note: The calculation result of swap is the value of op2, because the function of the swap instruction is to write a value to the memory address hi of op1 and return the original value of the address.

### MULDIV Support

- If `E203_SUPPORT_SHARE_MULDIV` is defined, this module can accept calculation requests from the muldiv module.

- Arithmetic Operations: add,sub

### Shared Buffers (SBFs)
- Two shared buffers (`sbf_0` and `sbf_1`) are used to store intermediate results for AGU and MULDIV operations.

## Clock and Reset

**Clock**: The module operates on the `clk` signal, which synchronizes all d flip-flop.

**Reset**: The module doesn't respond to `rst_n`