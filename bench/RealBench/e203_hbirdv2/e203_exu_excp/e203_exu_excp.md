# e203_exu_excp.v Specification

## Introduction

The `e203_exu_excp` module is responsible for handling exceptions and interrupts in the RISC-V processor. It manages various types of exceptions, including ALU exceptions, long-pipe exceptions, and debug-related exceptions. The module also handles the WFI (Wait for Interrupt) instruction and ensures proper flushing of the pipeline when exceptions occur.

## Module Diagram

![module_diagram](figures/e203_exu_excp_module_diagram.png)

## Interface

| Direction | Port Name                | Width            | Description |
| --------- | ------------------------ | ---------------- | ----------- |
| output    | commit_trap              | 1                | Indicates a trap has been committed |
| output    | core_wfi                 | 1                | Indicates the core is in WFI state |
| output    | wfi_halt_ifu_req         | 1                | Request to halt the IFU due to WFI |
| output    | wfi_halt_exu_req         | 1                | Request to halt the EXU due to WFI |
| input     | wfi_halt_ifu_ack         | 1                | Acknowledge from IFU for WFI halt request |
| input     | wfi_halt_exu_ack         | 1                | Acknowledge from EXU for WFI halt request |
| input     | amo_wait                 | 1                | Indicates AMO instruction is waiting |
| output    | alu_excp_i_ready         | 1                | Ready signal for ALU exception |
| input     | alu_excp_i_valid         | 1                | ALU exception valid signal |
| input     | alu_excp_i_ld            | 1                | ALU load exception |
| input     | alu_excp_i_stamo         | 1                | ALU store/AMO exception |
| input     | alu_excp_i_misalgn       | 1                | ALU misalignment exception |
| input     | alu_excp_i_buserr        | 1                | ALU bus error exception |
| input     | alu_excp_i_ecall         | 1                | ALU ecall exception |
| input     | alu_excp_i_ebreak        | 1                | ALU ebreak exception |
| input     | alu_excp_i_wfi           | 1                | ALU WFI exception |
| input     | alu_excp_i_ifu_misalgn   | 1                | IFU misalignment exception |
| input     | alu_excp_i_ifu_buserr    | 1                | IFU bus error exception |
| input     | alu_excp_i_ifu_ilegl     | 1                | IFU illegal instruction exception |
| input     | alu_excp_i_badaddr       | E203_ADDR_SIZE   | Bad address for ALU exception |
| input     | alu_excp_i_pc            | E203_PC_SIZE     | PC value associated with ALU exception |
| input     | alu_excp_i_instr         | E203_INSTR_SIZE  | Instruction causing ALU exception |
| input     | alu_excp_i_pc_vld        | 1                | PC value valid signal |
| input     | longp_excp_i_valid       | 1                | Long-pipe exception valid signal |
| input     | longp_excp_i_ld          | 1                | Long-pipe load exception |
| input     | longp_excp_i_st          | 1                | Long-pipe store exception |
| input     | longp_excp_i_buserr      | 1                | Long-pipe bus error exception |
| input     | longp_excp_i_insterr     | 1                | Long-pipe instruction error |
| input     | longp_excp_i_badaddr     | E203_ADDR_SIZE   | Bad address for long-pipe exception |
| input     | longp_excp_i_pc          | E203_PC_SIZE     | PC value associated with long-pipe exception |
| output    | longp_excp_i_ready       | 1                | Ready signal for long-pipe exception |
| input     | excpirq_flush_ack        | 1                | Acknowledge for exception/interrupt flush |
| output    | excpirq_flush_req        | 1                | Request to flush pipeline due to exception/interrupt |
| output    | nonalu_excpirq_flush_req_raw | 1             | Raw request to flush pipeline for non-ALU exceptions/interrupts |
| output    | excpirq_flush_add_op1    | E203_PC_SIZE     | Operand 1 for flush address calculation |
| output    | excpirq_flush_add_op2    | E203_PC_SIZE     | Operand 2 for flush address calculation |
| output    | excpirq_flush_pc         | E203_PC_SIZE     | Direct PC value for flush address (available if `E203_TIMING_BOOST` is defined) |
| input     | csr_mtvec_r              | E203_XLEN        | CSR mtvec value |
| input     | cmt_dret_ena             | 1                | Debug return enable |
| input     | cmt_ena                  | 1                | Commit enable |
| output    | cmt_badaddr              | E203_ADDR_SIZE   | Bad address for exception |
| output    | cmt_epc                  | E203_PC_SIZE     | Exception PC |
| output    | cmt_cause                | E203_XLEN        | Exception cause |
| output    | cmt_badaddr_ena          | 1                | Enable for bad address update |
| output    | cmt_epc_ena              | 1                | Enable for EPC update |
| output    | cmt_cause_ena            | 1                | Enable for cause update |
| output    | cmt_status_ena           | 1                | Enable for status update |
| output    | cmt_dpc                  | E203_PC_SIZE     | Debug PC |
| output    | cmt_dpc_ena              | 1                | Enable for debug PC update |
| output    | cmt_dcause               | 3                | Debug cause |
| output    | cmt_dcause_ena           | 1                | Enable for debug cause update |
| input     | dbg_irq_r                | 1                | Debug interrupt request |
| input     | lcl_irq_r                | E203_LIRQ_NUM    | Local interrupt requests |
| input     | ext_irq_r                | 1                | External interrupt request |
| input     | sft_irq_r                | 1                | Software interrupt request |
| input     | tmr_irq_r                | 1                | Timer interrupt request |
| input     | status_mie_r             | 1                | Machine interrupt enable |
| input     | mtie_r                   | 1                | Machine timer interrupt enable |
| input     | msie_r                   | 1                | Machine software interrupt enable |
| input     | meie_r                   | 1                | Machine external interrupt enable |
| input     | dbg_mode                 | 1                | Debug mode |
| input     | dbg_halt_r               | 1                | Debug halt request |
| input     | dbg_step_r               | 1                | Debug step request |
| input     | dbg_ebreakm_r            | 1                | Debug ebreak request |
| input     | oitf_empty               | 1                | OITF empty signal |
| input     | u_mode                   | 1                | User mode |
| input     | s_mode                   | 1                | Supervisor mode |
| input     | h_mode                   | 1                | Hypervisor mode |
| input     | m_mode                   | 1                | Machine mode |
| output    | excp_active              | 1                | Exception active signal |
| input     | clk                      | 1                | Clock signal |
| input     | rst_n                    | 1                | Reset signal |

## Submodules

**wfi_flag_dfflr**:sirv_gnrl_dfflr

**wfi_halt_req_dfflr**:sirv_gnrl_dfflr

**step_req_dfflr**:sirv_gnrl_dfflr

### sirv_gnrl_dfflr

#### Parameter Configuration

| Parameter Name | Default Value | Description |
|----------------|---------------|-------------|
| DW             | 32            | Data width (in bits) |

#### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| lden      | Input     | 1     | Load enable signal |
| dnxt      | Input     | DW    | Input data |
| qout      | Output    | DW    | Output data |
| clk       | Input     | 1     | Clock signal |
| rst_n     | Input     | 1     | Active-low reset signal |


## Function Description

### Exception Handling

The module handles various types of exceptions, including:

- **ALU Exceptions**: load, store, amo, misalignment, bus errors, ecall, ebreak, WFI, and ifu_misalgn, ifu_bus errors, ifu_ilegl exceptions.
- **Long-Pipe Exceptions**: Load/store bus errors and instruction errors.
- **Debug Exceptions**: Debug-related interrupts and exceptions, including ebreak, debug halt, and step requests.
- **Interruptions**: external-interruptions, software interruption, timer-interruption and debug interruption

When entering an exception, the following hardware actions are required:

1. The processor stops executing the current program flow and starts executing from the PC address defined by the mtvec register

2. Entering an exception not only causes the processor to start executing from the above PC address, but also causes the hardware to update the following four registers

1. Machine mode exception cause (machine cause, mcause)

2. Machine mode exception PC (machine exception program counter, mepc)

3. Machine mode exception value (machine trap value, mtval)

4. Machine mode status (machine status, mstatus)

In this module, we are only responsible for updating the first three registers

#### PC switching

When an interrupt or exception occurs, the module pulls up the `excpirq_flush_req` signal to request a pipeline flush. In order to reduce the number of logic gates required for hardware implementation, the operand is passed to the IFU module, and the IFU adder is reused to calculate the PC of the instruction that needs to jump. The logic of operand assignment is as follows:

1. `excpirq_flush_add_op1`

   - If the request for processor flushing comes from entering debug mode, it is 0x800
   - Otherwise, if the request for processor flushing comes from a long pipeline exception or alu exception, and the current mode is debug, it is 0x808
   - Otherwise, it is the value in the mtvec control status register
2. `excpirq_flush_add_op2`
   - Always 0


If E203_TIMING_BOOST is defined in `e203_defines.v`, the module will directly output the PC value of the instruction fetched after pipeline flushing `excpirq_flush_pc`, and the value of this signal is the sum of the above two operands.

#### Pipeline flushing

When an exception or interrupt occurs, the processor will jump to the exception/interrupt handler. Since the subsequent instructions have been fetched at this time, the pipeline needs to be flushed. For the Hummingbird e203 processor, there are four types of requests that trigger pipeline flushing:

1. Long pipeline flushing request: When a long pipeline exception is returned by the long pipeline arbitration module, a long pipeline flushing request is generated
2. Debug mode entry flushing request: This flushing request is generated only when the following four requirements are met at the same time
   - When the processor currently does not have a long pipeline flushing request
   - The `alu_excp_i_pc_vld` signal is high
   - The oitf queue is empty (the `oitf_empty` signal is high)
   - The processor generates a debug mode entry request

    > Logic requirements for the generation of debug mode entry requests:
    >
    > 1. The processor is not in debug mode
    > 2. One of the following five requests exists:
    > 1. Debug interrupt request:
    > 2. Debug pause request
    > 3. Debug step request
    > 4. Debug trigger request
    > 5. Debug ebreak request: When the exception type is alu ebreak, alu does not need flushing, `dbg_ebreakm_r` is high level, `alu_excp_i_valid` is high level

3. Interrupt flushing request: This flushing request will only be generated when the following requirements are met at the same time

    - There is no long pipeline flushing request at present
    - There is no debug mode entry request at present
    - `alu_excp_i_pc_vld` signal is high
    - oitf queue is empty
    - The processor generates an interrupt request

4. alu abnormal flushing request: This flushing request will only be generated when the following requirements are met at the same time

    - There is no long pipeline flushing request at present

    - There is no debug mode entry request at present

    - There is no interrupt request at present

    - oitf queue is empty

    - There is an alu abnormality at present

    - alu needs flushing

        > When the following four situations occur, it means that alu needs flushing
        >
        > 1. alu_excp_i_misalgn
        > 2. alu_excp_i_buserr
        > 3. alu_excp_i_ebreak. dbg_ebreakm_r is low (indicates that the break signal is not used to enter debug mode) or is currently in debug mode
        > 4. alu_excp_i_ecall
        > 5. alu_excp_i_ifu_misalgn
        > 6. alu_excp_i_ifu_buserr
        > 7. alu_excp_i_ifu_ilegl

#### Register update

When the processor is not in debug mode and an interrupt or exception occurs, the status control registers such as mcause, mepc, mstatus, and mbadaddr can be updated; this module also controls the update of the status control registers exclusive to the debug mode.

<!--TODO：debug专有的状态控制寄存器的更新逻辑-->

##### mcause register

The exception handling module updates the mcause register according to the request type and specific number received. When an interrupt request is received, the lower 4 bits of mcause are updated to the corresponding interrupt number according to the interrupt type, and the highest bit is assigned to 1; when an exception request is received, the lower 5 bits of mcause are updated to the corresponding exception number according to the number.

###### exception table

| Name                           | serial number | signal                              |
| ------------------------------ | ---- | --------------------------------- |
| Instruction address misaligned | 0    | alu_excp_flush_req_ifu_misalgn    |
| Instruction access fault       | 1    | alu_excp_flush_req_ifu_buserr     |
| Illegal instruction            | 2    | alu_excp_flush_req_ifu_ilegl      |
| Breakpoint                     | 3    | alu_excp_flush_req_ebreak         |
| load address misalign          | 4    | alu_excp_flush_req_ld_misalgn     |
| load access fault              | 5    | longp_excp_flush_req_ld_buserr    |
| Store/AMO address misalign     | 6    | alu_excp_flush_req_stamo_misalgn  |
| Store/AMO access fault         | 7    | longp_excp_flush_req_st_buserr    |
| Environment call from U-mode   | 8    | alu_excp_flush_req_ecall & u_mode |
| Environment call from S-mode   | 9    | alu_excp_flush_req_ecall & s_mode |
| Environment call from H-mode   | 10   | alu_excp_flush_req_ecall & h_mode |
| Environment call from M-mode   | 11   | alu_excp_flush_req_ecall & m_mode |
| NICE long instructions         | 16   | longp_excp_flush_req_insterr      |

###### interruption number

| Name                       | serial number | signal               |
| -------------------------- | ---- | ------------------ |
| Machine software interrupt | 3    | sft_irq_r & msie_r |
| Machine timer interrupt    | 7    | tmr_irq_r & mtie_r |
| Machine external interrupt | 11   | ext_irq_r & meie_r |

##### mepc register

Update the epc register according to the exception type. When the exception is a long pipeline exception, update it to the input long pipeline exception PC value, otherwise update it to the alu exception PC value.

##### mtval（mbadaddr）

Consider the following situations in order:

1. If it is a long pipeline load/store exception, assign it to long pipeline exception badaddr

2. If it is a flush caused by alu's submodule agu, assign it to alu_excp_i_badaddr

   <!--TODO: Specific update logic-->

3. If it is alu_excp_flush_req_ebreak or alu_excp_flush_req_ifu_misalgn or alu_excp_flush_req_ifu_buserr, update it to the PC value of alu input

4. If it is alu_excp_flush_req_ifu_ilegl, update it to alu_excp_i_instr

5. If none of the above conditions are met, update it to 0

##### mstatus

This module is not responsible for assigning values ​​to the mstatus register, but only outputs the enable signal for updating the register

### WFI Handling

The module manages the WFI (Wait for Interrupt) instruction, ensuring the core enters a low-power state and wakes up upon receiving an interrupt.

#### WFI related signals

| Signal name | Direction | Description |
| :----------------- | :--- | :-------------------------- |
| `core_wfi` | Output | High level indicates that the processor is in WFI state |
| `wfi_halt_ifu_req` | Output | Request to halt the instruction fetch unit (IFU) |
| `wfi_halt_exu_req` | Output | Request to halt the execution unit (EXU) |
| `wfi_halt_ifu_ack` | Input | IFU confirms that the halt is completed |
| `wfi_halt_exu_ack` | Input | EXU confirms that the halt is completed |
| `alu_excp_i_wfi` | Input | ALU indicates that the current instruction is WFI |

#### WFI status trigger

1. **Instruction submission**
When the ALU submits the WFI instruction (`alu_excp_i_wfi & cmt_ena`) and is not in debug mode, pull high `wfi_halt_ifu_req` and `wfi_halt_exu_req` to halt the IFU and EXU. In order to make sure the flush to IFU and halt to IFU is not asserted at the same cycle we use the clr signal here to qualify `wfi_halt_ifu_req`. To cut the comb loops, we don't use the clr signal here to qualify, the outcome is the halt-to-exu will be deasserted 1 cycle later than to-IFU, but it doesn't matter much.

2. **Handshake confirmation**

When both IFU and EXU confirm the halt (`wfi_halt_ifu_ack & wfi_halt_exu_ack`), pull `core_wfi` high

#### WFI state exit

The processor exits the WFI state when any of the following conditions are met:

1. **Interrupt request**: valid interrupt (interrupt request received and interrupt enable of this type is turned on) and not masked (`~wfi_irq_mask`)

2. **Debug event**: debug entry request (`dbg_entry_req`)

Exit process:

- Set `core_wfi` to low immediately
- cancel IFU/EXU pause request synchronously with clock

## Clock and Reset

- **Clock**: The module operates on the rising edge of the `clk` signal.
- **Reset**: The module is reset asynchronously by the `rst_n` signal. All internal states are reset to their default values upon reset.