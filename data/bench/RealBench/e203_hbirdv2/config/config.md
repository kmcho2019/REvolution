# E203 Processor Configuration Document

## 1. Introduction

This document describes the configuration system for the E203 processor. The E203 is a RISC-V architecture-based processor core that can be configured with various features and functional modules via macro definitions. This configuration file is licensed under the Apache 2.0 open-source license and is maintained by Nuclei System Technology.

## 2. Basic Configuration Items

### 2.1 Debug and Interrupt Configuration
- **`E203_CFG_DEBUG_HAS_JTAG`**: Enables support for JTAG debug interface.
- **`E203_CFG_IRQ_NEED_SYNC`**: Enables interrupt synchronization mechanism.

### 2.2 Address Space Configuration
The system supports three address width configurations, and only one can be selected at a time:
- **`E203_CFG_ADDR_SIZE_IS_16`**: 16-bit address space.
- **`E203_CFG_ADDR_SIZE_IS_24`**: 24-bit address space.
- **`E203_CFG_ADDR_SIZE_IS_32`**: 32-bit address space (currently selected configuration).

The address size is unified through the **`E203_CFG_ADDR_SIZE`** macro, which is automatically set based on the chosen configuration.

### 2.3 CPU Function Configuration
- **`E203_CFG_SUPPORT_MCYCLE_MINSTRET`**: Enables support for MCYCLE and MINSTRET counters.
- **`E203_CFG_REGNUM_IS_32`**: Configures the number of registers to 32.
- **`E203_CFG_HAS_ECC`**: Enables ECC (Error Correction Code) functionality.
- **`E203_CFG_HAS_NICE`**: Enables the NICE instruction extension.
- **`E203_CFG_SUPPORT_SHARE_MULDIV`**: Enables shared multiplication and division units.
- **`E203_CFG_SUPPORT_AMO`**: Enables support for atomic memory operations (AMO).

## 2.4 Memory System Configuration

### Instruction TCM (ITCM)
- **`E203_CFG_HAS_ITCM`**: Enables Instruction Tightly Coupled Memory (ITCM).
- **`E203_CFG_ITCM_ADDR_WIDTH`**: Configures the ITCM address width. The current setting is 16 bits.
  - Supports a 64KB configuration (16-bit address width, 8192 depth).
  - Optional 1024KB configuration (20-bit address width).
  - Optional 2048KB configuration (21-bit address width).

### Data TCM (DTCM)
- **`E203_CFG_HAS_DTCM`**: Enables Data Tightly Coupled Memory (DTCM).
- **`E203_CFG_DTCM_ADDR_WIDTH`**: Configures the DTCM address width. The current setting is 16 bits.
  - Supports a 16KB configuration (14-bit address width, 4096 depth).
  - Supports a 256KB configuration (18-bit address width, 65536 depth).
  - Optional 1MB configuration (20-bit address width, 262144 depth).

## 2.5 Memory Mapping Configuration

The system defines the base addresses for the following memory regions:

1. **ITCM Region**:
   - Base address: `0x8000_0000`
   - Defined through **`E203_CFG_ITCM_ADDR_BASE`**.
2. **DTCM Region**:
   - Base address: `0x9000_0000`
   - Defined through **`E203_CFG_DTCM_ADDR_BASE`**.
3. **Peripheral Interface Regions**:
   - **PPI Region**: `0x1000_0000 - 0x1FFF_FFFF`
   - Defined through **`E203_CFG_PPI_ADDR_BASE`** and **`E203_CFG_PPI_BASE_REGION`**.
4. **System Controller Regions**:
   - **CLINT Region**: `0x0200_0000 - 0x0200_FFFF`
   - Base Address of CLINT is defined through **`E203_CFG_CLINT_ADDR_BASE`**.(`E203_CFG_ADDR_SIZE'h0200_0000`)
   -  **`E203_CFG_CLINT_BASE_REGION`** macro defines the high address range used to determine whether an address belongs to CLINT REGION (`E203_CFG_ADDR_SIZE-1:E203_CFG_ADDR_SIZE-16`)
   - **PLIC Region**: `0x0C00_0000 - 0x0CFF_FFFF`
   - Base Address of PLIC is defined through **`E203_CFG_PLIC_ADDR_BASE`**.(`E203_CFG_ADDR_SIZE'h0C00_0000`)
   -  **`E203_CFG_PLIC_BASE_REGION`** macro defines the high address range used to determine whether an address belongs to PLIC REGION (`E203_CFG_ADDR_SIZE-1:E203_CFG_ADDR_SIZE-8`)
5. **Fast IO Region**:
   - Base address: `0xF000_0000`
   - Defined through **`E203_CFG_FIO_ADDR_BASE`** and **`E203_CFG_FIO_BASE_REGION`**.

## 3. Notes

1. Only one address width configuration should be enabled at a time.
2. TCM configurations should be selected based on available hardware resources.
3. Memory mapping configurations must avoid address overlap.
4. It is recommended to carefully evaluate the system's resource requirements and performance demands when modifying configurations.

