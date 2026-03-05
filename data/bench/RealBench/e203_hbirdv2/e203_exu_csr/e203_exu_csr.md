# e203_exu_csr.v Specification

## Introduction

The `e203_exu_csr` module implements the core's CSR interface, which manages the reading and writing of various CSR registers in the system. These registers include machine status, interrupt enable registers, machine exception program counter, trap cause, and additional custom registers specific to the implementation. The module also includes logic for managing privileged modes (user, supervisor, hypervisor, and machine), handling interrupts, and processing machine-level control operations.

## Module Diagram

![module_diagram](figures/e203_exu_csr_module_diagram.png)

This module consists of several sections that handle specific CSRs, such as:
- **Machine Status Registers**: This includes control over interrupt enable and privilege mode (e.g., `mstatus`, `mie`, `mip`).
- **Machine Exception Handling**: Handles exception program counters and trap causes (e.g., `mepc`, `mcause`).
- **Performance Counters**: Tracks cycles, instructions, and other performance metrics (e.g., `mcycle`, `minstret`).
- **Custom Control Registers**: Includes registers for power management, clock gating, and feature control (e.g., `counterstop`, `mcgstop`, `itcmnohold`).
- **Debug Interface**: Manages debug-specific registers like `dcsr`, `dpc`, and `dscratch`.

## Interface

**Basic Interface**

| Direction | Port Name                        | Width                         | Description                                                                                  |
| --------- | --------------------------------- | ----------------------------- | -------------------------------------------------------------------------------------------- |
| input | nonflush_cmt_ena | 1 | Currently not used in implementation                                                  |
| input     | csr_ena                           | 1                             | Enable signal for CSR operations                                                              |
| input     | csr_wr_en                         | 1                             | Write enable signal for CSR                                                                  |
| input     | csr_rd_en                         | 1                             | Read enable signal for CSR                                                                   |
| input     | csr_idx                           | 12                            | Index of the CSR being accessed                                                              |
| output    | csr_access_ilgl                   | 1                             | Illegal access indicator for CSR operations                                                  |
| output    | tm_stop                           | 1                             | Stop signal for the time counter                                                             |
| output    | core_cgstop                       | 1                             | Core clock gating stop signal                                                                |
| output    | tcm_cgstop                        | 1                             | TCM clock gating stop signal                                                                  |
| output    | itcm_nohold                       | 1                             | ITCM no hold-up feature indicator                                                            |
| output    | mdv_nob2b                         | 1                             | Disable mul/div back-to-back feature indicator                                               |
| output    | read_csr_dat                      | E203_XLEN                     | Data read from the CSR                                                                      |
| input     | wbck_csr_dat                      | E203_XLEN                     | Data to be written to the CSR                                                                |
| input     | core_mhartid                      | E203_HART_ID_W                | Core hardware thread ID                                                                       |
| input     | ext_irq_r                          | 1                             | External interrupt request                                                                   |
| input     | sft_irq_r                          | 1                             | Software interrupt request                                                                   |
| input     | tmr_irq_r                          | 1                             | Timer interrupt request                                                                      |
| output    | status_mie_r                      | 1                             | Machine interrupt enable status                                                              |
| output    | mtie_r                            | 1                             | Machine timer interrupt enable status                                                        |
| output    | msie_r                            | 1                             | Machine software interrupt enable status                                                     |
| output    | meie_r                            | 1                             | Machine external interrupt enable status                                                     |
| output    | wr_dcsr_ena                       | 1                             | Write enable signal for `dcsr` register                                                      |
| output    | wr_dpc_ena                        | 1                             | Write enable signal for `dpc` register                                                       |
| output    | wr_dscratch_ena                   | 1                             | Write enable signal for `dscratch` register                                                  |
| input     | dcsr_r                            | E203_XLEN                     | Debug control and status register                                                            |
| input     | dpc_r                             | E203_PC_SIZE                  | Debug program counter register                                                                |
| input     | dscratch_r                        | E203_XLEN                     | Debug scratch register                                                                       |
| output    | u_mode                            | 1                             | User mode status (always set to 0)                                                           |
| output    | s_mode                            | 1                             | Supervisor mode status (always set to 0)                                                    |
| output    | h_mode                            | 1                             | Hypervisor mode status (always set to 0)                                                    |
| output    | m_mode                            | 1                             | Machine mode status (always set to 1)                                                        |
| input     | cmt_badaddr                       | E203_ADDR_SIZE                | Commit bad address for exception handling                                                   |
| input     | cmt_badaddr_ena                   | 1                             | Enable signal for commit bad address                                                        |
| input     | cmt_epc                           | E203_PC_SIZE                  | Commit exception program counter for exception handling                                      |
| input     | cmt_epc_ena                       | 1                             | Enable signal for commit exception program counter                                          |
| input     | cmt_cause                         | E203_XLEN                     | Commit exception cause for exception handling                                               |
| input     | cmt_cause_ena                     | 1                             | Enable signal for commit exception cause                                                   |
| input     | cmt_status_ena                    | 1                             | Enable signal for commit status register updates                                           |
| input     | cmt_instret_ena                   | 1                             | Enable signal for commit instruction retirement register updates                            |
| input     | cmt_mret_ena                      | 1                             | Enable signal for commit return from exception (MRET)                                       |
| output    | csr_epc_r                         | E203_PC_SIZE                  | Read machine exception program counter                                                       |
| output    | csr_dpc_r                         | E203_PC_SIZE                  | Read debug program counter                                                                   |
| output    | csr_mtvec_r                       | E203_XLEN                     | Machine trap vector register                                                                  |
| input     | clk_aon                           | 1                             | Always-on clock for counters                                                                  |
| input     | clk                               | 1                             | Main clock signal                                                                             |
| input     | rst_n                             | 1                             | Reset signal (active low)                                                                    |

**Optional Interface**

those interface is available when `E203_HAS_NICE` is defined.

| Direction | Name        | Width | Description                   |
| --------- | ----------- | ----- | ----------------------------- |
| output    | nice_xs_off | 1     | Indicates that NICE is closed |

## Function Description

### CSR Access Control

- **Access Illegal Flag (`csr_access_ilgl`)**: 
  - This flag indicates if there was an illegal access attempt to the CSR register.
  - It is always set to 0 in this design, assuming no illegal access.
- **CSR Write and Read Operations**: 
  - The module allows reading and writing to various CSR registers, such as `mstatus`, `mie`, `mtvec`, `mepc`, and custom registers like `counterstop`, `mcgstop`, and `itcmnohold`. 
  - When `csr_ena` is 1, `csr_wr_en` is 1 and the access is not illegal, the value of variable `wbck_csr_dat` is written to the register corresponding to the index(`csr_idx`) at the rising edge.
  - When `csr_ena` is 1, `csr_rd_en` is 1 and the access is not illegal, The value of the register corresponding to the index(`csr_idx`) will be read.

### RISC-V CSR：

| CSR Address | Read/Write | Name            | Description                                      |
| ------- | -------- | --------------- | ------------------------------------------ |
| 0x000   | MRW      | ustaus          | User Status Register                       |
| 0x300   | MRW      | mstatus         | Machine Status Register                    |
| 0x301   | MRW      | misa            | Machine ISA Register                       |
| 0x304   | MRW      | mie             | Machine Interrupt Enable Register          |
| 0x305   | MRW      | mtvec           | Machine Trap-Vector Base-Address Register  |
| 0x340   | MRW      | mscratch        | Machine Scratch Register                   |
| 0x341   | MRW      | mepc            | Machine Exception Program Counter Register |
| 0x342   | MRW      | mcause          | Machine Cause                              |
| 0x343   | MRW      | mtval(mbadaddr) | Machine Trap Value Register                |
| 0x344       | MRW                   | mip          | Machine Interrupt Pending Register                   |
| 0xB00       | MRW                   | mcycle       | Lower 32 bits of Cycle counter                       |
| 0xB80       | MRW                   | mcycleh      | Upper 32 bits of Cycle counter                       |
| 0xB02       | MRW                   | minstret     | Lower 32 bits of Instructions-retired counter        |
| 0xB82       | MRW                   | minstreth    | Upper 32 bits of Instructions-retired counter        |
| 0xF11       | MRW                   | mvendorid    | Machine Vendor ID Register                           |
| 0xF12       | MRO                   | marchid      | Machine Architecture ID Register                     |
| 0xF13       | MRO                   | mimpid       | Machine Implementation ID Register                   |
| 0xF14   | MRO                   | mhartid      | Hart ID Register                                     |
| N/A         | MRW                   | mtime        | Machine-mode Timer Register                          |
| N/A         | MRW                   | mtimecmp     | Machine-mode Timer Compare Register                  |
| N/A         | MRW                   | msip         | Machine-mode Software Interrupt Pending Register     |

**Update Rule**

- mstatus

  | Bits  | Description | Default Value |
  | ----- | ----------- | ------------- |
  | 31    | SD          | 0             |
  | 30:23 | Reserved    | 0             |
  | 22:17 | TSR--MPRV   | 0             |
  | 16:15 | XS          | 0             |
  | 14:13 | FS          | 0             |
  | 12:11 | MPP         | 2'b11         |
  | 10:9  | Reserved    | 0             |
  | 8     | SPP         | 0             |
  | 7     | MPIE        | 0             |
  | 6     | Reserved    | 0             |
  | 5     | SPIE        | 0             |
  | 4     | UPIE        | 0             |
  | 3     | MIE         | 0             |
  | 2     | Reserved    | 0             |
  | 1     | SIE         | 0             |
  | 0     | UIE         | 0             |

  - MPIE field:
    - When a trap is taken from privilege mode y into privilege mode x, xPIE is set to the value of xIE; So when the Trap is taken(`cmt_status_ena` is 1), the MPIE is updated with the current MIE value.
    - When executing an xRET instruction(`cmt_mret_ena` is 1), supposing xPP holds the value y, xIE is set to xPIE; the privilege mode is changed to y; xPIE is set to 1;
    - When the CSR is written by CSR instructions, MPIE is in field 7 of mstatus.

  - MIE:

    - When a trap is taken from privilege mode y into privilege mode x, xPIE is set to the value of xIE, xIE is set to 0; So, When the Trap is taken(`cmt_status_ena` is 1) , the MIE is updated with 0.
    - When executing an xRET instruction, supposing xPP holds the value y, xIE is set to xPIE; the privilege mode is changed to y, xPIE is set to 1; So, When the MRET instruction commited (`cmt_mret_ena` is 1), the MIE is updated with MPIE. 
    - When the CSR is written by CSR instructions, MIE is in field 3 of mstatus


  - SD:

    - The SD bit is read-only. And is set when either the FS or XS bits encode a Dirty state (i.e., SD=((FS==11) OR (XS==11))).
    - In this module, XS is assign to 0;


  - XS:

    - XS field is read-only
    - The XS field represents a summary of all extensions' status. But we implement XS exactly same as FS to make it usable by software to disable extended accelerators
    - If no NICE coprocessor interface configured(`ifndef E203_HAS_NICE`), the XS is just hardwired to 0


  - FS:

    - If no FPU configured(`ifndef E203_HAS_FPU`), the FS is just hardwired to 0

- mie

  | Bits  | Description | Default Value |
  | ----- | ----------- | ------------- |
  | 31:12 | Reserved    | 0             |
  | 11    | MEIE        | 0             |
  | 10    | Reserved    | 0             |
  | 9     | SEIE        | 0             |
  | 8     | UEIE        | 0             |
  | 7     | MTIE        | 0             |
  | 6     | Reserved    | 0             |
  | 5     | STIE        | 0             |
  | 4     | UTIE        | 0             |
  | 3     | MSIE        | 0             |
  | 2     | Reserved    | 0             |
  | 1     | SSIE        | 0             |
  | 0     | USIE        | 0             |

- mip

  | Bits  | Description | Default Value |
  | ----- | ----------- | ------------- |
  | 31:12 | Reserved    | 0             |
  | 11    | MEIP        | 0             |
  | 10    | Reserved    | 0             |
  | 9     | SEIP        | 0             |
  | 8     | UEIP        | 0             |
  | 7     | MTIP        | 0             |
  | 6     | Reserved    | 0             |
  | 5     | STIP        | 0             |
  | 4     | UTIP        | 0             |
  | 3     | MSIP        | 0             |
  | 2     | Reserved    | 0             |
  | 1     | SSIP        | 0             |
  | 0     | USIP        | 0             |

- mtvec

  - If `E203_SUPPORT_MTVEC` is defined, mtvec register can be written with csr instructions.
  - else mtvec is assigned to `E203_MTVEC_TRAP_BASE`

- mscratch

  - If `E203_SUPPORT_MSCRATCH` is defined, mscratch register can be written with csr instructions.
  - else mscratch is assigned to `0`

- some signals

- mepc

  - When instructions write to this register or `cmt_epc_ena` is asserted, mepc register is updated.
  - we don't hold PC which will generate the misalign exception according to ISA, so LSB of mepc is assigned  to `0`. other bits is updated depending the update reason. If `cmt_epc_ena` is 1, mepc is updated with `cmt_epc`, else with `wbck_csr_dat`
  - The missing high bits are filled with 0

- mcause

  - When instructions write to this register or `cmt_cause_ena` is asserted, mcause register is updated. When the register is updated, only the value of bit 31 and values between bit 3 and bit 0 are replaced by the update source.
    - If `cmt_cause_ena` is 1, mcause register is updated with the value of `cmt_cause`.
    - else mcause register is updated with the value of `wbck_csr_dat`

- mbadaddr

  - When instructions write to this register or `cmt_trap_badaddr_ena` is asserted, mbadaddr register is updated. 
    - If `cmt_trap_badaddr_ena` is 1, mcause register is updated with the value of `cmt_badaddr`.
    - else mcause register is updated with the bits between `E203_ADDR_SIZE-1` and `0` of `wbck_csr_dat`
  - The missing high bits are filled with 0

- misa

  | Bits                    | Description                                               | Value                                                        |
  | ----------------------- | --------------------------------------------------------- | ------------------------------------------------------------ |
  | E203_XLEN-1:E203_XLEN-2 | Architecture                                              | 1 for RV32, 2 for RV64, 3 for RV128                          |
  | E203_XLEN-3:26          | Reserved                                                  | 0                                                            |
  | 25                      | Reserved                                                  | 0                                                            |
  | 24                      | Reserved                                                  | 0                                                            |
  | 23                      | Non-standard extensions present                           | 0                                                            |
  | 22                      | Reserved                                                  | 0                                                            |
  | 21                      | Tentatively reserved for Vector extension                 | 0                                                            |
  | 20                      | User mode implemented                                     | 0                                                            |
  | 19                      | Tentatively reserved for Transactional Memory extension   | 0                                                            |
  | 18                      | Supervisor mode implemented                               | 0                                                            |
  | 17                      | Reserved                                                  | 0                                                            |
  | 16                      | Quad-precision floating-point extension                   | 0                                                            |
  | 15                      | Tentatively reserved for Packed-SIMD extension            | 0                                                            |
  | 14                      | Reserved                                                  | 0                                                            |
  | 13                      | User-level interrupts supported                           | 0                                                            |
  | 12                      | Integer Multiply/Divide extension                         | 1                                                            |
  | 11                      | Tentatively reserved for Decimal Floating-Point extension | 0                                                            |
  | 10                      | Reserved                                                  | 0                                                            |
  | 9                       | Reserved                                                  | 0                                                            |
  | 8                       | RV32I/64I/128I base ISA                                   | if `E203_RFREG_NUM_IS_32` is defined, the value is 1, otherwise 0 |
  | 7                       | Hypervisor mode implemented                               | 0                                                            |
  | 6                       | Additional standard extensions present                    | 0                                                            |
  | 5                       | Single-precision floating-point extension                 | if `E203_HAS_FPU` is not defined, the value is 0             |
  | 4                       | RV32E base ISA                                            | if `E203_RFREG_NUM_IS_32` is defined, the value is 0, otherwise 1 |
  | 3                       | Double-precision floating-point extension                 | if `E203_HAS_FPU` is not defined, the value is 0             |
  | 2                       | Compressed extension                                      | 1                                                            |
  | 1                       | Tentatively reserved for Bit operations extension         | 0                                                            |
  | 0                       | Atomic extension                                          | if `E203_SUPPORT_AMO` is defined, the value is 1, otherwise 0 |

- mvendorid: 536

- marchid: E203

- mimpid: 1

- mhartid: `core_mhartid`

### Custom Registers

| CSR Address | Read/Write | Name         | Description                                       |
| ----------- | ---------- | ------------ | ------------------------------------------------- |
| 0xBFF       | MRW        | mcounterstop | Custom register, for stopping mtime, mcycle, etc. |

- **Counterstop (`counterstop`)**: 
  - A custom register used to stop cycle, time, and instruction count counters to save power.

- **Machine Clock Gating Control (`mcgstop`)**: 
  - Controls clock gating for core logic and TCM (tight-coupled memory).

- **ITCM No Hold-up (`itcmnohold`)**: 
  - Disables the hold-up feature of ITCM (Instruction Tightly Coupled Memory) to avoid stalling data read.

- **Mul/Div No Back-to-Back (`mdvnob2b`)**: 
  - Disables the back-to-back execution of multiplication and division operations.

### Debug CSR

These debug CSR can be read/written only when CPU is in debug mode (`dbg_mode=1`)

- **Debug Control and Status Register (`dcsr`)**: 
  - Address: 0x7b0
  - A CSR used for controlling and monitoring the debug interface.
  
- **Debug Program Counter (`dpc`)**: 
  - Address: 0x7b1
  - Holds the program counter for debugging purposes.

- **Debug Scratch Register (`dscratch`)**: 
  - Address: 0x7b2
  - A general-purpose scratch register used for debugging.


### CSR Read

According to the index value, return the value in the corresponding register. If there is no special instruction, the missing high bits are filled with 0.

## Implementation Detail

Currently this module only supports the M mode to simplify the implementation and reduce the gate count. So `m_mode=1`, while `u_mode`, `s_mode`, and `h_mode=0`.

### Clock and Reset

- **Clock Signals**: 
  - The module operates based on the `clk` signal, with an always-on clock (`clk_aon`) used for counters like `mcycle`. All register update on the positive edge of clock.
- **Reset**: 
  - The module is reset using the `rst_n` signal, which is active low.