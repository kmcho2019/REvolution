# ITCM Controller Design Document

## 1. Introduction
The ITCM (Instruction Tightly Coupled Memory) Controller is a multi-port memory access controller responsible for managing and arbitrating access requests to the ITCM from the IFU (Instruction Fetch Unit), LSU (Load Store Unit), and external interfaces. This module implements functions such as priority arbitration, data width conversion, and timing control.

## 2. Block Diagram

![](./figures/e203_itcm_ctrl_blockdiagram.png)

## 3. Interface Description

### 3.1 System Interfaces
| Signal Name | Direction | Width | Description |
|-------------|-----------|--------|-------------|
| clk | Input | 1 | System clock |
| rst_n | Input | 1 | Active low reset |
| test_mode | Input | 1 | Test mode enable |
| itcm_active | Output | 1 | ITCM active status |
| tcm_cgstop | Input | 1 | Clock gating stop signal |

### 3.2 IFU Interface
| Signal Name | Direction | Width | Description |
|-------------|-----------|--------|-------------|
| ifu2itcm_icb_cmd_valid | Input | 1 | Command valid |
| ifu2itcm_icb_cmd_ready | Output | 1 | Command ready |
| ifu2itcm_icb_cmd_addr | Input | ADDR_WIDTH | Access address |
| ifu2itcm_icb_cmd_read | Input | 1 | Read enable |
| ifu2itcm_icb_cmd_wdata | Input | DATA_WIDTH | Write data |
| ifu2itcm_icb_cmd_wmask | Input | WMSK_WIDTH | Write mask |
| ifu2itcm_icb_rsp_valid | Output | 1 | Response valid |
| ifu2itcm_icb_rsp_ready | Input | 1 | Response ready |
| ifu2itcm_icb_rsp_err | Output | 1 | Response error |
| ifu2itcm_icb_rsp_rdata | Output | DATA_WIDTH | Read data |
| ifu2itcm_holdup | Output | 1 | Holdup Signal |

### 3.3 LSU Interface  
(Same structure as IFU Interface, signal names prefixed with lsu2itcm_)
| Signal Name | Direction | Width | Description |
|-------------|-----------|--------|-------------|
| lsu2itcm_icb_cmd_valid | Input | 1 | Command valid |
| lsu2itcm_icb_cmd_ready | Output | 1 | Command ready |
| lsu2itcm_icb_cmd_addr | Input | ADDR_WIDTH | Access address |
| lsu2itcm_icb_cmd_read | Input | 1 | Read enable |
| lsu2itcm_icb_cmd_wdata | Input | DATA_WIDTH | Write data |
| lsu2itcm_icb_cmd_wmask | Input | WMSK_WIDTH | Write mask |
| lsu2itcm_icb_rsp_valid | Output | 1 | Response valid |
| lsu2itcm_icb_rsp_ready | Input | 1 | Response ready |
| lsu2itcm_icb_rsp_err | Output | 1 | Response error |
| lsu2itcm_icb_rsp_rdata | Output | DATA_WIDTH | Read data |

### 3.4 External Interface
(Same structure as IFU Interface, signal names prefixed with ext2itcm_, only exists when E203_HAS_ITCM_EXTITF is defined)
| Signal Name | Direction | Width | Description |
|-------------|-----------|--------|-------------|
| ext2itcm_icb_cmd_valid | Input | 1 | Command valid |
| ext2itcm_icb_cmd_ready | Output | 1 | Command ready |
| ext2itcm_icb_cmd_addr | Input | ADDR_WIDTH | Access address |
| ext2itcm_icb_cmd_read | Input | 1 | Read enable |
| ext2itcm_icb_cmd_wdata | Input | DATA_WIDTH | Write data |
| ext2itcm_icb_cmd_wmask | Input | WMSK_WIDTH | Write mask |
| ext2itcm_icb_rsp_valid | Output | 1 | Response valid |
| ext2itcm_icb_rsp_ready | Input | 1 | Response ready |
| ext2itcm_icb_rsp_err | Output | 1 | Response error |
| ext2itcm_icb_rsp_rdata | Output | DATA_WIDTH | Read data |

### 3.5 RAM Interface
| Signal Name | Direction | Width | Description |
|-------------|-----------|--------|-------------|
| itcm_ram_cs | Output | 1 | Chip select |
| itcm_ram_we | Output | 1 | Write enable |
| itcm_ram_addr | Output | RAM_AW | Address |
| itcm_ram_wem | Output | RAM_MW | Write mask |
| itcm_ram_din | Output | RAM_DW | Write data |
| itcm_ram_dout | Input | RAM_DW | Read data |
| clk_itcm_ram | Output | 1 | RAM clock |

## 4. Called Modules

### 4.1 Data Width Conversion Module (module:sirv_gnrl_icb_n2w)

**Function Description**: Implements data width conversion for the ICB bus interface, supporting conversion from a narrower data bus (e.g., 32 bits) to a wider data bus (e.g., 64 bits). The module integrates a FIFO to support pipelined operations, and the configurable depth meets different performance requirements. During the data conversion process, the position of the data in the wide bus is determined according to the address information, and the write mask is adjusted accordingly.

#### LSU Interface Instance (u_itcm_icb_lsu2itcm_n2w)

**Parameter Configuration**:

| Parameter | Value | Description |
|-----------|-------|-------------|
| AW | E203_ITCM_ADDR_WIDTH | Address bus width |
| USR_W | 1 | User-defined signal width |
| FIFO_OUTS_NUM | E203_ITCM_OUTS_NUM | FIFO depth, supporting 1 or multiple outstanding requests |
| FIFO_CUT_READY | 0 | Ready signal pass-through mode enable |
| X_W | 32 | Input (narrow) data bus width |
| Y_W | E203_ITCM_DATA_WIDTH | Output (wide) data bus width |

**Input ICB Interface Signals**:
| Signal Name | Width | Description |
|-------------|-------|-------------|
| i_icb_cmd_valid | 1 | Input command valid signal |
| i_icb_cmd_ready | 1 | Input command ready signal |
| i_icb_cmd_read | 1 | Read/write indication (1: read, 0: write) |
| i_icb_cmd_addr | AW | Access address |
| i_icb_cmd_wdata | X_W | Write data (32 bits) |
| i_icb_cmd_wmask | X_W/8 | Byte write enable mask (4 bits) |
| i_icb_cmd_lock | 1 | Bus lock signal |
| i_icb_cmd_excl | 1 | Exclusive access signal |
| i_icb_cmd_size | 2 | Transfer size |
| i_icb_cmd_burst | 2 | Burst transfer type |
| i_icb_cmd_beat | 2 | Burst transfer beat count |
| i_icb_cmd_usr | USR_W | User-defined information |
| i_icb_rsp_valid | 1 | Input response valid |
| i_icb_rsp_ready | 1 | Input response ready |
| i_icb_rsp_err | 1 | Error indication |
| i_icb_rsp_excl_ok | 1 | Exclusive access success flag |
| i_icb_rsp_rdata | X_W | Read data |
| i_icb_rsp_usr | USR_W | Response user information |

**Output ICB Interface Signals**:
| Signal Name | Width | Description |
|-------------|-------|-------------|
| o_icb_cmd_valid | 1 | Output command valid |
| o_icb_cmd_ready | 1 | Output command ready |
| o_icb_cmd_read | 1 | Read/write indication |
| o_icb_cmd_addr | AW | Address |
| o_icb_cmd_wdata | Y_W | Extended write data (64 bits) |
| o_icb_cmd_wmask | Y_W/8 | Extended write mask (8 bits) |
| o_icb_cmd_lock | 1 | Lock signal |
| o_icb_cmd_excl | 1 | Exclusive access signal |
| o_icb_cmd_size | 2 | Transfer size |
| o_icb_cmd_burst | 2 | Burst type |
| o_icb_cmd_beat | 2 | Burst beat count |
| o_icb_cmd_usr | USR_W | User information |
| o_icb_rsp_valid | 1 | Output response valid |
| o_icb_rsp_ready | 1 | Output response ready |
| o_icb_rsp_err | 1 | Error indication |
| o_icb_rsp_excl_ok | 1 | Exclusive access result |
| o_icb_rsp_rdata | Y_W | 64-bit read data |
| o_icb_rsp_usr | USR_W | Response user information |

**Other Interface Signals**:
| Signal Name | Width | Description |
|-------------|-------|-------------|
| clk | 1 | System clock |
| rst_n | 1 | Asynchronous reset (low active) |

#### EXT Interface Instance (u_itcm_icb_ext2itcm_n2w)

**Parameter Configuration**:

| Parameter      | Value                  | Description                                               |
| -------------- | ---------------------- | --------------------------------------------------------- |
| AW             | E203_ITCM_ADDR_WIDTH   | Address bus width                                         |
| USR_W          | 1                      | User-defined signal width                                 |
| FIFO_OUTS_NUM  | E203_ITCM_OUTS_NUM     | FIFO depth, supporting 1 or multiple outstanding requests |
| FIFO_CUT_READY | 0                      | Ready signal pass-through mode enable                     |
| X_W            | E203_SYSMEM_DATA_WIDTH | Input (narrow) data bus width                             |
| Y_W            | E203_ITCM_DATA_WIDTH   | Output (wide) data bus width                              |

The EXT interface and the LSU interface use the same submodule, so their interface information is the same, but their parameter configurations are slightly different.

### 4.2 Bus Arbiter Module (sirv_gnrl_icb_arbt)

**Function Description**: Implements multi-way arbitration for the ICB bus, supporting priority and round-robin arbitration strategies. Integrates a FIFO to support multiple outstanding requests, and uses port ID tracking to ensure responses are returned to the correct request port. The module supports 0-cycle responses and pipelined operations, and configurable parameters balance performance and resource consumption.

#### Module Instance Configuration

##### Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| DW                 | 64            | Data width (in bits) |
| USR_W              | 1             | User-defined signal width |
| ARBT_SCHEME        | 0             | Arbitration scheme (0: priority-based, 1: round-robin) |
| FIFO_OUTS_NUM      | 1             | Number of outstanding transactions supported |
| FIFO_CUT_READY     | 0             | Controls whether the ready signal is cut to avoid logic chains |
| ARBT_NUM           | 4             | Number of ICB ports |
| ALLOW_0CYCL_RSP    | 1             | Allows 0-cycle response |
| ARBT_PTR_W         | 2             | Width of the arbitration pointer |

##### Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| o_icb_cmd_valid | Output | 1 | Command valid to slave |
| o_icb_cmd_ready | Input | 1 | Command ready from slave |
| o_icb_cmd_read | Output | 1 | Read/write indicator (1=read) |
| o_icb_cmd_addr | Output | AW | Command address |
| o_icb_cmd_wdata | Output | DW | Write data |
| o_icb_cmd_wmask | Output | DW/8 | Write mask |
| o_icb_cmd_burst | Output | 2 | Burst type |
| o_icb_cmd_beat | Output | 2 | Beat type |
| o_icb_cmd_lock | Output | 1 | Lock signal |
| o_icb_cmd_excl | Output | 1 | Exclusive access |
| o_icb_cmd_size | Output | 2 | Transfer size |
| o_icb_cmd_usr | Output | USR_W | User-defined signal |
| o_icb_rsp_valid | Input | 1 | Response valid from slave |
| o_icb_rsp_ready | Output | 1 | Response ready to slave |
| o_icb_rsp_err | Input | 1 | Response error |
| o_icb_rsp_excl_ok | Input | 1 | Exclusive access ok |
| o_icb_rsp_rdata | Input | DW | Read data |
| o_icb_rsp_usr | Input | USR_W | User-defined response signal |
| i_bus_icb_cmd_ready | Output | ARBT_NUM | Command ready to masters |
| i_bus_icb_cmd_valid | Input | ARBT_NUM | Command valid from masters |
| i_bus_icb_cmd_read | Input | ARBT_NUM | Read/write indicators |
| i_bus_icb_cmd_addr | Input | ARBT_NUM*AW | Command addresses |
| i_bus_icb_cmd_wdata | Input | ARBT_NUM*DW | Write data |
| i_bus_icb_cmd_wmask | Input | ARBT_NUM*DW/8 | Write masks |
| i_bus_icb_cmd_burst | Input | ARBT_NUM*2 | Burst types |
| i_bus_icb_cmd_beat | Input | ARBT_NUM*2 | Beat types |
| i_bus_icb_cmd_lock | Input | ARBT_NUM | Lock signals |
| i_bus_icb_cmd_excl | Input | ARBT_NUM | Exclusive access |
| i_bus_icb_cmd_size | Input | ARBT_NUM*2 | Transfer sizes |
| i_bus_icb_cmd_usr | Input | ARBT_NUM*USR_W | User-defined signals |
| i_bus_icb_rsp_valid | Output | ARBT_NUM | Response valid to masters |
| i_bus_icb_rsp_ready | Input | ARBT_NUM | Response ready from masters |
| i_bus_icb_rsp_err | Output | ARBT_NUM | Response errors |
| i_bus_icb_rsp_excl_ok | Output | ARBT_NUM | Exclusive access ok |
| i_bus_icb_rsp_rdata | Output | ARBT_NUM*DW | Read data to masters |
| i_bus_icb_rsp_usr | Output | ARBT_NUM*USR_W | User-defined signals |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 4.3 SRAM Controller Module (sirv_sram_icb_ctrl)

**Function Description**: Implements the control function from the ICB bus interface to the SRAM memory. The module contains a command buffer unit (bypbuf) for cutting off the backpressure signal and integrates a single-cycle SRAM controller. Supports clock gating to reduce power consumption and can control the clock gating function during debugging through CSR registers.

#### SRAM Controller Configuration

**Parameter Configuration**:

| Parameter | Value | Description |
|-----------|-------|-------------|
| DW | E203_ITCM_DATA_WIDTH | Data bus width (only supports 32 or 64 bits) |
| MW | E203_ITCM_WMSK_WIDTH | Write mask width |
| AW | E203_ITCM_ADDR_WIDTH | Address bus width |
| AW_LSB | 3 | Width of the least significant bits of the address |
| USR_W | 2 | User-defined signal width |

**Signal Interface**

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| sram_ctrl_active | Output | 1 | Active status indicator for clock gating control |
| tcm_cgstop | Input | 1 | Clock gating stop signal from CSR (for debugging) |
| i_icb_cmd_valid | Input | 1 | ICB command valid signal |
| i_icb_cmd_ready | Output | 1 | ICB command ready signal |
| i_icb_cmd_read | Input | 1 | Read/write indicator (1 = read) |
| i_icb_cmd_addr | Input | AW | Command address |
| i_icb_cmd_wdata | Input | DW | Write data |
| i_icb_cmd_wmask | Input | MW | Write mask |
| i_icb_cmd_usr | Input | USR_W | User-defined command signals |
| i_icb_rsp_valid | Output | 1 | ICB response valid signal |
| i_icb_rsp_ready | Input | 1 | ICB response ready signal |
| i_icb_rsp_rdata | Output | DW | Read data response |
| i_icb_rsp_usr | Output | USR_W | User-defined response signals |
| ram_cs | Output | 1 | RAM chip select |
| ram_we | Output | 1 | RAM write enable |
| ram_addr | Output | AW-AW_LSB | RAM address |
| ram_wem | Output | MW | RAM write enable mask |
| ram_din | Output | DW | RAM data input |
| ram_dout | Input | DW | RAM data output |
| clk_ram | Output | 1 | RAM clock signal |
| test_mode | Input | 1 | Test mode enable |
| clk | Input | 1 | System clock |
| rst_n | Input | 1 | Reset signal (active low) |

Note: The module cuts off the backpressure signal through the byp_icb command buffer and tracks multiple active status signals to control clock gating, thus achieving low power consumption while ensuring functionality.


## 5. Implementation Details

### 5.1 Data Width Conversion Implementation

The `itcmctrl` module uses the `n2w` module for converting 32-bit data to 64-bit data. The detailed process is as follows:

1. **LSU Data Conversion**:
   - When `itcmctrl` receives a 32-bit data request from LSU, it calls the `n2w` module to convert the 32-bit data and the corresponding 4-bit write mask into 64-bit data. During this process, the module checks the address (the least significant bit) to determine the position of the data in the 64-bit output and adjusts the alignment of the data and mask accordingly.

2. **Unaligned Address Handling**:
   - If the LSU data request is unaligned, the `n2w` module handles the address conversion and data reordering, correctly combining the 32-bit data into 64-bit data, and ensures the mask width is extended to 8 bits to match the 64-bit data bus.

3. **FIFO for Ordering**:
   - The `itcmctrl` module uses the `n2w` module to ensure the order of requests, guaranteeing that multiple parallel requests are processed sequentially and preventing data misalignment.

4. **External Interface Conversion (Optional)**:
   - If there is an external interface request, the `itcmctrl` module also uses the `n2w` module to convert the data, ensuring that external interface data is compatible with the 64-bit width requirement. Additional consideration is given to the signal validity and timing synchronization for external interface requests.

### 5.2 Access Arbitration Implementation Flow

Use the sirv_gnrl_icb_arbt module for access arbitration:

1. First-level arbitration processing:
   - Detect the cmd_valid signal of all input ports.
   - Select the LSU directly when the LSU port is valid.
   - When the LSU is invalid and the external interface is valid, select the external interface.
   - Generate arbt_bus_icb_cmd_ready for the unselected ports.

2. Second-level arbitration processing:
   - Check the validity of the first-level arbitration output and the validity of the IFU request.
   - Record the currently processing request source through a state machine.
   - When a new request intervenes, wait for the completion of the current request before switching.
   - The arbitration result is passed to the data selection circuit through the sram_sel_ signal.

3. Data selection process:
   - Select the corresponding data path according to the sram_sel_ signal.
   - Multiplex the address, data, and control signals.
   - Connect the ready signal of the selected channel directly to the SRAM controller.
   - Keep the ready signal of the unselected channel low.

### 5.3 SRAM Access Control Implementation Flow
Rely on the sirv_sram_icb_ctrl module (when the E203_HAS_ECC macro is not defined) to implement SRAM access control:

1. Command stage processing:
   - After receiving an access request, record the request source identifier to the usr field.
   - Generate the RAM's chip select and write enable signals according to the read/write signal.
   - Shift the address right by 3 bits to remove the byte offset and obtain the RAM's physical address.
   - Generate the byte enable signal when writing according to the wmask signal.

2. Access stage process:
   - Generate the RAM's control signals. After the setup and hold times are satisfied, issue the chip select signal.
   - When reading, sample the data after waiting for the RAM output to stabilize.
   - When writing, ensure that the data and mask signals are established before writing.
   - After the RAM responds, revoke the chip select signal and wait for the next access.

3. Response stage processing:
   - Extract the request source information from the usr field.
   - Route and select the response channel according to the request source.
   - Establish a handshake and wait for the target port to receive the data.
   - After the response is received, clear the relevant state and prepare to process the next request.

### 5.4 Holdup Mechanism Implementation Flow
1. IFU access tracking:
   - Sample the sram_icb_cmd_ifu signal every time the RAM is accessed.
   - When detecting IFU access and itcm_ram_cs is valid, set the ifu_holdup_set signal.
   - Store the ifu_holdup_set signal in the ifu_holdup_r register.
   - The ifu_holdup_r state will be maintained until a non-IFU access occurs.

2. State switching processing:
   - When detecting non-IFU access and itcm_ram_cs is valid, set the ifu_holdup_clr signal.
   - The ifu_holdup_clr signal will clear the ifu_holdup_r register.
   - When the clr and set signals are simultaneously valid, handle the clr signal first.
   - When the reset signal is triggered, directly clear the ifu_holdup_r register.

3. State synchronization:
   - The change of the ifu_holdup signal is updated on the rising edge of the clock.
   - Use ifu_holdup_ena to control the state update timing.
   - Ensure no glitches during state switching.
   - Output the final state through the ifu2itcm_holdup signal.

### 5.5 Clock Control Implementation Flow
1. Main clock processing:
   - The RAM clock is controlled by a gating unit.
   - When tcm_cgstop is high, disable the clock gating.
   - Generate the gating enable signal according to the RAM access state.
   - Ensure no glitches occur during clock switching.

2. Test mode processing:
   - Detect the state of the test_mode signal.
   - In test mode, bypass the clock gating logic.
   - Directly use the system clock to drive the RAM.
   - Synchronize all relevant states when switching the test mode.

### 5.6 Error Handling Process
1. Error detection:
   - Capture cases of non-aligned address access.
   - Monitor whether the access address exceeds the range.
   - Check for violations of the handshake protocol.
   - Record the specific cause of the error.

2. Error response generation:
   - Set the rsp_err signal according to the error type.
   - Return the error status through the current response channel.
   - Automatically reset the relevant control state after an error occurs.
   - Prepare to receive the next access request.

## 6. Corner Cases

1. Concurrent access handling:
   - When multiple ports request simultaneously, ensure the correctness of arbitration.
   - Avoid starvation.

2. Data width conversion boundaries:
   - Address alignment issues when converting from 32 bits to 64 bits.
   - Handling of cross-boundary access.

3. Request switching timing:
   - Ensure that the RAM control signals are stable when requests are switched.
   - Prevent glitches.

4. Reset state handling:
   - Ensure that all state machines are correctly reset.
   - Prevent metastability.

## 7. Constraints

1. Mutual exclusion constraints:
   - sram_sel_ifu and sram_sel_arbt cannot be 1 simultaneously.
   - ext2itcm and lsu2itcm's cmd_valid cannot be 1 simultaneously.

2. Timing constraints:
   - RAM interface signals must meet setup and hold times.
   - The release of the synchronous reset signal must meet the minimum pulse width.

3. Functional constraints:
   - Only support naturally aligned access.
   - LSU and external interfaces must be 32 bits wide.
   - ITCM must be 64 bits wide.

4. Configuration constraints:
   - External interface functionality is controlled by E203_HAS_ITCM_EXTITF.
   - ECC functionality is controlled by E203_HAS_ECC.