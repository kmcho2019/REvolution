# E203 Processor Configuration Design Document

## 1. Introduction
The E203 is a configurable RISC-V processor core that implements high configurability through macro definitions. This document details the configuration parameters and architectural design of the E203 processor.

## 2. Detailed Configuration Specifications

### 2.1 ISA Core Configuration

#### 2.1.1 ISA-Related Macros
- Address Space Configuration
  - Macros related to the address and program counter (PC) size for the `E203` core are based on the configured address size(`E203_CFG_ADDR_SIZE_IS_X`)
  - The address size and PC size are determined by the user-defined configuration macros:
    - `E203_CFG_ADDR_SIZE_IS_16`
    - `E203_CFG_ADDR_SIZE_IS_24`
    - `E203_CFG_ADDR_SIZE_IS_32`
  - If a specific configuration macro (e.g., `E203_CFG_ADDR_SIZE_IS_32`) is defined, the corresponding address size and PC size macros are also defined:
    - `E203_ADDR_SIZE_IS_32` 
    - `E203_PC_SIZE_IS_32`
    -  `E203_ADDR_SIZE` is set to 32
    - `E203_PC_SIZE` is set to 32
  
- Base ISA Configuration
  - 32-bit instruction length (`E203_INSTR_SIZE` is defined as 32)
  - Supports 32-bit data width
    - define `E203_XLEN_IS_32`
    - `E203_XLEN` is defined as 32
    - `E203_XLEN_MW` is defined as 4
  - Configurable register file numbers (4/8/16/32)
    - If a specific configuration macro (e.g., `E203_CFG_REGNUM_IS_32`) is defined, the corresponding register number macros are defined:
      - `E203_RFREG_NUM_IS_32`
      - `E203_RFREG_NUM` is defined as 32
- CSR Configuration
  - Supports MSCRATCH register (`E203_SUPPORT_MSCRATCH`)
  - Supports MTVEC register (`E203_SUPPORT_MTVEC`)
  - Optional support for MCYCLE/MINSTRET counters
    - If `E203_CFG_SUPPORT_MCYCLE_MINSTRET` is defined, `E203_SUPPORT_MCYCLE_MINSTRET` will be defined.
- PPI/CLINT/PLIC/FIO Configuration
  - `E203_PPI_ADDR_BASE`, `E203_PPI_BASE_REGION` are defined with related CFG macro (`E203_CFG_PPI_ADDR_BASE`, `E203_CFG_PPI_BASE_REGION`)
  - `E203_CLINT_ADDR_BASE`, `E203_CLINT_BASE_REGION` are defined with related CFG macro (`E203_CFG_CLINT_ADDR_BASE`, `E203_CFG_CLINT_BASE_REGION`)
  - `E203_PLIC_ADDR_BASE`, `E203_PLIC_BASE_REGION` are defined with related CFG macro (`E203_CFG_PLIC_ADDR_BASE`, `E203_CFG_PLIC_BASE_REGION`)
  - `E203_FIO_ADDR_BASE`, `E203_FIFO_BASE_REGION` are defined with related CFG macro (`E203_CFG_FIO_ADDR_BASE`, `E203_CFG_FIO_BASE_REGION`)

- TCM Configuration
  - `E203_DTCM_ADDR_BASE` is configured by `E203_CFG_DTCM_ADDR_BASE`
  - `E203_ITCM_ADDR_BASE` is configured by `E203_CFG_ITCM_ADDR_BASE`


#### 2.1.2 ISA Implementation Detail

- `E203_REGFILE_LATCH_BASED`
  - This macro is defined only if `E203_CFG_REGFILE_LATCH_BASED` is defined and `FPGA_SOURCE` is not defined.

### 2.2 Interface Configuration

#### 2.2.1 Interface-Related Macros
- Processor Interface
  - Supports 1 HART (`E203_HART_NUM`)
  - HART ID Width is defined as 1 (`E203_HART_ID_W`)
  - Supports 1 local interrupt source (`E203_LIRQ_NUM`)
  - Supports debug module configuration (`E203_DEBUG_HAS_DM`)
  - Optional Support Interruption Request Sync
    - define `E203_IRQ_NEED_SYNC` if `E203_CFG_IRQ_NEED_SYNC` is defined
  - Optional Support JTAG Debug Interface
    - define `E203_DEBUG_HAS_JTAG` if `E203_CFG_DEBUG_HAS_JTAG` is defined
  
- Bus Interface
  - define `E203_HAS_MEM_ITF`
  - Supports 32/64-bit system bus data width. (current 32)
    - If a specific configuration macro (e.g., `E203_CFG_SYSMEM_DATA_WIDTH_IS_32`) is defined, the corresponding system data width macros are defined:
      - `E203_SYSMEM_DATA_WIDTH_IS_32`
      - `E203_SYSMEM_DATA_WIDTH` is defined as 32
  - Supports standard peripheral interfaces (PPI, PLIC, CLINT)
    - `E203_HAS_PPI`
    - `E203_HAS_PLIC`
    - `E203_HAS_CLINT`
    - `E203_HAS_FIO`
  - Optional Support NICE
    - define the NICE feature (`E203_HAS_NICE`) if `E203_CFG_HAS_NICE` is defined
  

### 2.3 Memory Configuration

#### 2.3.1 ITCM Configuration
- **Optional ITCM Support**:
  - If the macro `E203_CFG_HAS_ITCM` is defined, the following features related to ITCM are enabled:
    - `E203_HAS_ITCM `1: Indicates that ITCM is supported in the design.
    - `E203_ITCM_ADDR_WIDTH`: Sets the address width of the ITCM, derived from the configuration macro `E203_CFG_ITCM_ADDR_WIDTH`.
- **ITCM Memory Depth and Address Width**:
  - ITCM memory depth and address width are calculated based on the address width:
    - ITCM Depth (`E203_ITCM_RAM_DP`):
      - The memory depth is computed as 2^(addr_width−3), where `addr_width` is `E203_CFG_ITCM_ADDR_WIDTH`.
      - This is because ITCM is 64 bits wide (8 bytes per line), so the depth is divided by 8.
    - ITCM Address Width (`E203_ITCM_RAM_AW`):
      - The address width for accessing ITCM is `E203_CFG_ITCM_ADDR_WIDTH` reduced by 3 bits to account for byte addressing within 64-bit memory lines.
  - ITCM Base Region (`E203_ITCM_BASE_REGION`):
    - Specifies the high bits of the address range for ITCM, which are used to determine if an address falls within the ITCM region.
- **Data Width Configuration**:
  - ITCM supports a data width of 64 bits (default configuration):
    - `E203_CFG_ITCM_DATA_WIDTH_IS_64`: When defined, the following macros are set:
      - `E203_ITCM_DATA_WIDTH`: ITCM data width is set to 64 bits.
      - `E203_ITCM_WMSK_WIDTH`: Write mask width is 8 (one mask bit per byte).
      - `E203_ITCM_RAM_ECC_DW`: ECC data width is 8 bits.
      - `E203_ITCM_RAM_ECC_MW`: ECC mask width is 1 bit.
- **ECC (Error Correction Code) Handling**:
  - If ECC is not enabled (is not defined):
    - `E203_ITCM_RAM_DW`: ITCM data width defined as `E203_ITCM_DATA_WIDTH`.
    - `E203_ITCM_RAM_MW`: Write mask width defined as `E203_ITCM_WMSK_WIDTH`.
    - `E203_ITCM_OUTS_NUM`: ITCM allows only **1 outstanding transaction** for external agents due to its 1-cycle latency without ECC.
- **External ITCM Interface**:
  - `E203_HAS_ITCM_EXTITF`: Indicates the presence of an external ITCM interface, allowing communication with other components.

#### 2.3.2 DTCM Configuration
- **Optional DTCM Support**:
  - If `E203_CFG_HAS_DTCM` is defined, the following features related to DTCM are enabled:
    - `E203_HAS_DTCM` 1 : Indicates that DTCM is supported in the design.
    - `E203_DTCM_ADDR_WIDTH`: Sets the address width of DTCM, derived from the configuration macro `E203_CFG_DTCM_ADDR_WIDTH`.
- **DTCM Memory Depth and Address Width**:
  - DTCM Depth (`E203_DTCM_RAM_DP`):
    - The memory depth is computed as 2^(addr_width−2), where `addr_width` is `E203_CFG_DTCM_ADDR_WIDTH`.
    - This is because DTCM is 32 bits wide (4 bytes per line), so the depth is divided by 4.
  - DTCM Address Width (`E203_DTCM_RAM_AW`):
    - The address width for accessing DTCM is reduced by 2 bits to account for byte addressing within 32-bit memory lines.
  - DTCM Base Region (`E203_DTCM_BASE_REGION`):
    - Specifies the high bits of the address range for DTCM, which are used to determine if an address falls within the DTCM region.
- **Data Width Configuration**:
  - DTCM data width is fixed at 32 bits:
    - `E203_DTCM_DATA_WIDTH`: Sets the data width to 32 bits.
    - `E203_DTCM_WMSK_WIDTH`: Write mask width is 4 (one mask bit per byte).
- **ECC (Error Correction Code) Handling**:
  - If ECC is supported:
    - `E203_DTCM_RAM_ECC_DW`: ECC data width is set to 7 bits.
    - `E203_DTCM_RAM_ECC_MW`: ECC mask width is set to 1 bit.
  - If ECC is not supported (is not defined):
    - `E203_DTCM_RAM_DW`: Memory data width remains `E203_DTCM_DATA_WIDTH` (32 bits).
    - `E203_DTCM_RAM_MW`: Memory write mask width remains `E203_DTCM_WMSK_WIDTH` (4 bits).
    - `E203_DTCM_OUTS_NUM`: Only **1 outstanding transaction** is allowed for external agents, as DTCM without ECC operates with 1-cycle latency.
- **External Interface**:
  - `E203_HAS_DTCM_EXTITF`: Indicates the presence of an external DTCM interface, allowing communication with other components.

### 2.4 Functional Unit Configuration

#### 2.4.1 MULDIV Configuration
- - **Optional Support for Shared Multiply/Divide Unit**:
    - If `E203_CFG_SUPPORT_SHARE_MULDIV` is defined:
      - `E203_SUPPORT_MULDIV`: Indicates that the Multiply/Divide (MULDIV) functionality is supported in the design.
      - `E203_SUPPORT_SHARE_MULDIV`: Enables a **shared MULDIV unit** where multiply and divide operations share hardware resources,  optimizing area usage at the cost of potential performance trade-offs.
  - **Optional Support for Independent Multiply/Divide Unit**:
    - If `E203_CFG_SUPPORT_INDEP_MULDIV` is defined:
      - `E203_SUPPORT_MULDIV`: Indicates that the MULDIV functionality is supported in the design.
      - `E203_SUPPORT_INDEP_MUL_1CYC`: Enables an **independent multiplier** that performs multiplication in **1 cycle**, improving performance but requiring more hardware resources.

#### 2.4.2 ALU Configuration
1. **Definition of MULDIV Adder Width**:
   - `E203_MULDIV_ADDER_WIDTH` is defined as **35**, representing the width of the adder used in the Multiply and Divide  (MULDIV) unit. This value is specifically used when the shared MULDIV  configuration is enabled.
2. **Conditional ALU Adder Width Configuration**:
   - **Shared Multiply/Divide Unit** (if `E203_CFG_SUPPORT_SHARE_MULDIV` defined):
     - `E203_ALU_ADDER_WIDTH` is set to `E203_MULDIV_ADDER_WIDTH` (35 bits).
     - This indicates that the Arithmetic Logic Unit (ALU) uses the same adder as the shared MULDIV unit, optimizing resource usage.
   - **Independent Multiply/Divide Unit** (when `E203_CFG_SUPPORT_SHARE_MULDIV` not defined):
     - `E203_ALU_ADDER_WIDTH` is set to `E203_XLEN + 1`, where `E203_XLEN` typically represents the processor's data width (e.g., 32 or 64 bits).
     - This allows the ALU to have a separate, independent adder, ensuring higher performance and flexibility.

#### 2.4.3 MAS Configuration
- **Asynchronous Flip-Flop Levels**:
  - `E203_ASYNC_FF_LEVELS` is defined as **2**,  indicating two levels of flip-flops are used for asynchronous signal  synchronization. This is typically used to ensure data stability when  crossing clock domains.
- **OITF (Outstanding Instruction Tracking FIFO) Depth**:
  - The OITF tracks instructions that are dispatched but not yet retired. The depth of the OITF is configurable and determined by the following  conditions:
    - Default Configuration:
      - `E203_CFG_OITF_DEPTH_IS_2`: The default OITF depth is **2** entries to allow back-to-back instruction dispatch.
    - Independent Multiply/Divide Unit:
      - If `E203_CFG_SUPPORT_INDEP_MULDIV` is defined, the OITF depth is increased to **4** (`E203_CFG_OITF_DEPTH_IS_4`) to support the increased number of outstanding operations required for independent MULDIV execution.
    - Floating-Point Unit (FPU):
      - If `E203_CFG_HAS_FPU` is defined, the OITF depth is also increased to **4** (`E203_CFG_OITF_DEPTH_IS_4`) to handle additional floating-point instructions.
  - **Final Depth Selection**:
    - If `E203_CFG_OITF_DEPTH_IS_4` is defined:
      - `E203_OITF_DEPTH` is set to **4**.
      - `E203_ITAG_WIDTH` is set to **2 bits**, allowing tagging of up to 4 outstanding instructions.
    - Else, if `E203_CFG_OITF_DEPTH_IS_2` is defined:
      - `E203_OITF_DEPTH` is set to **2**.
      - `E203_ITAG_WIDTH` is set to **1 bit**, allowing tagging of up to 2 outstanding instructions.
- **FPU (Floating-Point Unit) Configuration**:
  - If `E203_CFG_HAS_FPU` is defined:
    - If `E203_CFG_FPU_DOUBLE` is defined:
      - Double-precision floating-point is enabled (`E203_FPU_DOUBLE`), and `E203_FLEN` is set to **64** (representing the bit width of floating-point registers).
    - Else:
      - Single-precision floating-point is used, and `E203_FLEN` is set to **32**.
  - If `E203_CFG_HAS_FPU` is not defined:
    - Floating-point operations default to single precision (`E203_FLEN` is set to 32).

#### 2.4.4 Instruction Decode Configuration

- Instruction Group Type Encoding (3 bits):

  | Macro                   | Value | Description                             |
  | ----------------------- | ----- | --------------------------------------- |
  | E203_DECINFO_GRP_WIDTH  | 3     | Bit Width used to indicate decode group |
  | E203_DECINFO_GRP_ALU    | 0     | alu decode group number                 |
  | E203_DECINFO_GRP_AGU    | 1     | agu decode group number                 |
  | E203_DECINFO_GRP_BJP    | 2     | bjp decode group number                 |
  | E203_DECINFO_GRP_CSR    | 3     | csr decode group number                 |
  | E203_DECINFO_GRP_MULDIV | 4     | muldiv decode group number              |
  | E203_DECINFO_GRP_NICE   | 5     | nice instruction decode group number    |
  | E203_DECINFO_GRP_FPU    | 6     | fpu instruction decode group number     |

- Instruction Group Type Encoding for FPU (2 bits):
  - E203_DECINFO_GRP_FPU_WIDTH 2
  - E203_DECINFO_GRP_FPU_FLSU 0
  - E203_DECINFO_GRP_FPU_FMAC 1
  - E203_DECINFO_GRP_FPU_FDIV 2
  - E203_DECINFO_GRP_FPU_FMIS 3

- Instruction Group 
- Instruction Group Field (`E203_DECINFO_GRP`):
  - `E203_DECINFO_GRP_LSB` is 0
  - `E203_DECINFO_GRP_MSB` is sum of `E203_DECINFO_GRP_LSB` and `E203_DECINFO_GRP_WIDTH-1`
  - `E203_DECINFO_GRP` 
    - Specifies the instruction category.
    - Located in the bit range: `E203_DECINFO_GRP_MSB : E203_DECINFO_GRP_LSB`.

- RV32 Instruction Field (`E203_DECINFO_RV32`):
  - `E203_DECINFO_RV32_LSB` is `(E203_DECINFO_GRP_MSB+1)`
  - `E203_DECINFO_RV32_MSB` is `(E203_DECINFO_RV32_LSB+1-1)`
  - `E203_DECINFO_RV32`
    - Indicates RV32 compliance.
    - Located in the bit range: `E203_DECINFO_RV32_MSB`:`E203_DECINFO_RV32_LSB`

- Sub-Decode Information Field (`E203_DECINFO_SUBDECINFO_LSB`):
  - Marks the starting position for fields that provide operation-specific decode details(`E203_DECINFO_RV32_MSB+1`).

#### 2.4.5 Detailed Configuration for Each Instruction Group:

1. ALU Group (Basic Arithmetic Logic Operations)

   The indication signals of different instructions are arranged from low to high in the decoded information bus. ALU Instruction Group start from `E203_DECINFO_SUBDECINFO_LSB`, each instruction/indication signal occupies 1 bit.

   - ADD

     Take add instruction indication signal as example. We define signals as below.

     - define `E203_DECINFO_ALU_ADD_LSB` as `E203_DECINFO_SUBDECINFO_LSB`
     - define `E203_DECINFO_ALU_ADD_MSB` as `(E203_DECINFO_ALU_ADD_LSB+1-1)`
     - define `E203_DECINFO_ALU_ADD` as `E203_DECINFO_ALU_ADD_MSB` :`E203_DECINFO_ALU_ADD_LSB `

   - SUB

   - XOR

   - SLL

   - SRL

   - SRA

   - OR

   - AND

   - SLT

   - SLTU

   - LUI

   - OP2IMM

   - OP1PC

   - NOP

   - ECAL

   - EBRK

   - WFI

   Finally, define `E203_DECINFO_ALU_WIDTH` as the msb of last indication signal (`E203_DECINFO_ALU_WFI_MSB+1`).

2. AGU Group (Address Generation Unit)

   The indication signals of different instructions are arranged from low to high in the decoded information bus. AGU Instruction Group start from `E203_DECINFO_SUBDECINFO_LSB`, each instruction/indication signal occupies **1/2 bit**.

   - LOAD 1bit

     Take load instruction indication signal as example. We define signals as below.

     - define `E203_DECINFO_AGU_LOAD_LSB` as `E203_DECINFO_SUBDECINFO_LSB`
     - define `E203_DECINFO_AGU_LOAD_MSB` as `(E203_DECINFO_AGU_LOAD_LSB+1-1)`
     - define `E203_DECINFO_AGU_LOAD` as `E203_DECINFO_AGU_LOAD_MSB` :`E203_DECINFO_AGU_LOAD_LSB `

   - STORE 1bit

   - SIZE 2bit

     Take SIZE signal as example. We define signals as below.

     - define `E203_DECINFO_SIZE_LSB` as `E203_DECINFO_AGU_STORE_MSB+1`
     - define `E203_DECINFO_SIZE_MSB` as `(E203_DECINFO_SIZE_LSB+2-1)`
     - define `E203_DECINFO_SIZE` as `E203_DECINFO_SIZE_MSB` :`E203_DECINFO_SIZE_LSB `

   - USIGN 1bit

   - EXCL 1bit

   - AMO 1bit

   - AMOSWAP 1bit

   - AMOADD 1bit

   - AMOAND 1bit

   - AMOOR 1bit

   - AMOXOR 1bit

   - AMOMAX 1bit

   - AMOMAXU 1bit

   - AMOMINU 1bit

   - OP2IMM 1bit

   Finally, define `E203_DECINFO_AGU_WIDTH` as the msb of last indication signal (`E203_DECINFO_AFU_OP2IMM_MSB+1`).

3. BJP Group (Branch Jump Unit)

   The indication signals of different instructions are arranged from low to high in the decoded information bus. BJP Instruction Group start from `E203_DECINFO_SUBDECINFO_LSB`, each instruction/indication signal occupies **1 bit**.

   - JUMP

     Take add instruction indication signal as example. We define signals as below.

     - define `E203_DECINFO_BJP_JUMP_LSB` as `E203_DECINFO_SUBDECINFO_LSB`
     - define `E203_DECINFO_BJP_JUMP_MSB` as `(E203_DECINFO_BJP_JUMP_LSB+1-1)`
     - define `E203_DECINFO_BJP_JUMP` as `E203_DECINFO_BJP_JUMP_MSB` :`E203_DECINFO_BJP_JUMP_LSB `

   - BEQ

   - BNE

   - BLT

   - BGT

   - BLTU

   - BGTU

   - BXX

   - MRET

   - DRET

   - FENCE

   - FENCEI

   Finally, define `E203_DECINFO_BJP_WIDTH` as the msb of last indication signal (`E203_DECINFO_BJP_FENCEI_MSB+1`).
4. CSR Group (Control Status Register)

   The indication signals of different instructions are arranged from low to high in the decoded information bus. CSR Instruction Group start from `E203_DECINFO_SUBDECINFO_LSB`, each instruction/indication signal occupies **1/12 bit**.

   - CSRRW 1bit
   - CSRRS 1bit
   - CSRRC 1bit
   - RS1IMM 1bit
   - ZIMMM 1bit
   - RS1IS0 1bit
   - CSRIDX 12bit

   Finally, define `E203_DECINFO_CSR_WIDTH` as the msb of last indication signal (`E203_DECINFO_CSR_CSRIDX_MSB+1`).
5. NICE group

   The indication signals of different instructions are arranged from low to high in the decoded information bus. NICE Instruction Group start from `E203_DECINFO_SUBDECINFO_LSB`, each instruction/indication signal occupies **27 bit**.

   - INSTR 27bit

   Finally, define `E203_DECINFO_NICE_WIDTH` as the msb of last indication signal (`E203_DECINFO_NICE_INSTR_MSB+1`).

6. FPU Group

   **FPU Group Field (`E203_DECINFO_FPU_GRP`)**:

   - Represents the functional group for FPU operations.
   - Bit range: `E203_DECINFO_FPU_GRP_LSB` to `E203_DECINFO_FPU_GRP_MSB`.
   - Width is determined by `E203_DECINFO_GRP_FPU_WIDTH`.

   **FPU Rounding Mode (`E203_DECINFO_FPU_RM`)**:

   - Specifies the rounding mode for FPU instructions.
   - Bit range: `E203_DECINFO_FPU_RM_LSB` to `E203_DECINFO_FPU_RM_MSB`.
   - 3 bits wide.

   **FPU User-defined Rounding Mode (`E203_DECINFO_FPU_USERM`)**:

   - Indicates whether the rounding mode is user-defined.
   - Bit range: `E203_DECINFO_FPU_USERM_LSB` to `E203_DECINFO_FPU_USERM_MSB`.
   - 1 bit wide.

7. FLSU Group

   - Floating-point load/store control
     - `E203_DECINFO_FLSU_LOAD` 1bit
     - `E203_DECINFO_FLSU_STORE` 1bit
   - Single/double precision support
     - `E203_DECINFO_FLSU_DOUBLE` 1bit
   - Immediate operation control
     - `E203_DECINFO_FLSU_OP2IMM` 1bit

   - Instruction width definition: 
     - `E203_DECINFO_FLSU_WIDTH`

6. FDIV Group (Floating-point Division Unit)

   - Floating-point division operation control
     - `E203_DECINFO_FDIV_DIV` 1bit


   - Floating-point square root operation control
     - `E203_DECINFO_FDIV_SQRT` 1bit


   - Single/double precision mode selection
     - E203_DECINFO_FDIV_DOUBLE 1bit


   - Instruction width definition: 
     - `E203_DECINFO_FDIV_WIDTH`

7. FMIS Group (Floating-point Miscellaneous Unit)

   all signals occupy 1bit.

   - Sign operation instructions (FSGNJ/FSGNJN/FSGNJX)

   - Floating-point move instructions (FMVXW)

   - Floating-point classification instruction (FCLASS)
   - FMVWX
     - Floating-point format conversion instructions:
       * Float-to-integer conversion (FCVTWS/FCVTWUS)
       * Integer-to-float conversion (FCVTSW/FCVT.SWU)
       * Single/double precision conversion (FCVTSD/FCVTDS)

   - CVTWD
   - CVTWUD
   - CVTDW
   - CVTDWU

   - Instruction width definition: `E203_DECINFO_FMIS_WIDTH`

8. FMAC Group (Floating-point Multiply-Add Unit)

   all signals occupy 1bit.

   - Fused multiply-add instructions (FMADD/FMSUB/FNMSUB/FNMADD)
     - Basic operation instructions:
       * Addition/Subtraction (FADD/FSUB)
       * Multiplication (FMUL)


   - Min/Max instructions (FMIN/FMAX)

   - Comparison instructions (FEQ/FLT/FLE)

   - Single/double precision mode control(DOUBLE)

   - Instruction width definition: `E203_DECINFO_FMAC_WIDTH`

9. MULDIV Group (Integer Multiplication Division Unit)

   all signals occupy 1bit.

   - Multiplication instructions:
     * MUL (Multiplication)
     * MULH (Signed high multiplication)
     * MULHSU (Mixed signed high multiplication)
     * MULHU (Unsigned high multiplication)

   - Division instructions:
     * DIV (Signed division)
     * DIVU (Unsigned division)
     * REM (Signed remainder)
     * REMU (Unsigned remainder)

   - Back-to-back execution control (B2B)

   - Instruction width definition: 
     - `E203_DECINFO_MULDIV_WIDTH`

10. E203_DECINFO_WIDTH is defined as `E203_DECINFO_NICE_WIDTH+1`

### 2.5 Memory Access and Bus Configuration

#### 2.5.1 LSU Configuration
- Supports 1 outstanding request
  - `E203_LSU_OUTS_NUM` is defined as 1
  - define `E203_LSU_OUTS_NUM_IS_1`

- Optional AMO atomic operation support
  - define `E203_SUPPORT_AMO` if `E203_CFG_SUPPORT_AMO` is defined.

- No unaligned access support

#### 2.5.2 BIU Configuration
- Outstanding Transactions (`E203_BIU_OUTS_NUM`):
  - DCache Support:
    - If E203_HAS_DCACHE is defined:
      - The BIU can support **2 or more outstanding transactions** (commented out in this specific code).
  - No DCache:
    - If E203_HAS_DCACHE is not defined:
      - `E203_BIU_OUTS_NUM` is set to the value of `E203_LSU_OUTS_NUM`, which represents the number of outstanding transactions supported by the Load-Store Unit (LSU).
      - If E203_LSU_OUTS_NUM_IS_1 is defined:
        - `E203_BIU_OUTS_NUM` is explicitly set to **1**.
        - Additional macros are defined to reflect this:
          - `E203_BIU_OUTS_NUM_IS_1`: Indicates that the BIU supports only 1 outstanding transaction.
          - `E203_BIU_OUTS_CNT_W`: The bit width to count outstanding transactions is set to **1**.
- Cutting Ready Signals (`E203_BIU_CMD_CUT_READY` and `E203_BIU_RSP_CUT_READY`):
  - To optimize timing and avoid potential combinational loops or critical paths between the LSU, IFU, core, and external system:
    - Ready signals are always "cut" (pipelined) by the BIU stage.
  - This ensures robust timing but may introduce minor performance  trade-offs, especially in low-end cores with a single outstanding  transaction.
- Pipeline Depth Configuration:
  - The depth of the BIU command and response buffers is determined by  whether the BIU supports only 1 outstanding transaction or more:
    - Single Outstanding Transaction (`E203_BIU_OUTS_NUM_IS_1`):
      - Both `E203_BIU_CMD_DP` (command depth) and `E203_BIU_RSP_DP_RAW` (raw response depth) are set to **1**, reflecting minimal buffering needs.
    - Multiple Outstanding Transactions:
      - Both `E203_BIU_CMD_DP` and `E203_BIU_RSP_DP_RAW` are set to **2**, using a ping-pong buffer to enable back-to-back throughput.
- Timing Boost (`E203_TIMING_BOOST`):
  - If E203_TIMING_BOOST is defined:
    - The BIU response depth (`E203_BIU_RSP_DP`) is set to the raw depth (`E203_BIU_RSP_DP_RAW`), ensuring sufficient buffering for timing optimization.(default config)
  - If not defined:
    - The BIU response depth is set to **0**, potentially reducing area usage but sacrificing timing improvements.

