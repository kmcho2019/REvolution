# sirv_gnrl_icbs Design Specification

## Introduction

The `sirv_gnrl_icbs.v` file implements a collection of bus interface modules for the ICB (Internal Configurable Bus) architecture. These modules handle bus arbitration, protocol conversion, width adaptation, and buffering to enable flexible interconnections between different bus interfaces.

## Interface

### 1. sirv_gnrl_icb_arbt

#### 1.1 Parameter Configuration

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

#### 1.2 Signal Interface

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

### 2. sirv_gnrl_icb_buffer

#### 2.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| DW                 | 64            | Data width (in bits) |
| USR_W              | 1             | User-defined signal width |
| CMD_DP             | 4             | Depth of the command buffer |
| RSP_DP             | 4             | Depth of the response buffer |
| CMD_CUT_READY      | 0             | Controls whether the ready signal is cut in the command buffer |
| RSP_CUT_READY      | 0             | Controls whether the ready signal is cut in the response buffer |

#### 2.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| icb_buffer_active | Output | 1 | Buffer active indicator |
| i_icb_cmd_valid | Input | 1 | Input command valid |
| i_icb_cmd_ready | Output | 1 | Input command ready |
| i_icb_cmd_read | Input | 1 | Read/write indicator |
| i_icb_cmd_addr | Input | AW | Command address |
| i_icb_cmd_wdata | Input | DW | Write data |
| i_icb_cmd_wmask | Input | DW/8 | Write mask |
| i_icb_cmd_lock | Input | 1 | Lock signal |
| i_icb_cmd_excl | Input | 1 | Exclusive access |
| i_icb_cmd_size | Input | 2 | Transfer size |
| i_icb_cmd_burst | Input | 2 | Burst type |
| i_icb_cmd_beat | Input | 2 | Beat type |
| i_icb_cmd_usr | Input | USR_W | User-defined signal |
| i_icb_rsp_valid | Output | 1 | Response valid |
| i_icb_rsp_ready | Input | 1 | Response ready |
| i_icb_rsp_err | Output | 1 | Response error |
| i_icb_rsp_excl_ok | Output | 1 | Exclusive access ok |
| i_icb_rsp_rdata | Output | DW | Read data |
| i_icb_rsp_usr | Output | USR_W | User-defined signal |
| o_icb_cmd_valid | Output | 1 | Output command valid |
| o_icb_cmd_ready | Input | 1 | Output command ready |
| o_icb_cmd_read | Output | 1 | Read/write indicator |
| o_icb_cmd_addr | Output | AW | Command address |
| o_icb_cmd_wdata | Output | DW | Write data |
| o_icb_cmd_wmask | Output | DW/8 | Write mask |
| o_icb_cmd_lock | Output | 1 | Lock signal |
| o_icb_cmd_excl | Output | 1 | Exclusive access |
| o_icb_cmd_size | Output | 2 | Transfer size |
| o_icb_cmd_burst | Output | 2 | Burst type |
| o_icb_cmd_beat | Output | 2 | Beat type |
| o_icb_cmd_usr | Output | USR_W | User-defined signal |
| o_icb_rsp_valid | Input | 1 | Response valid |
| o_icb_rsp_ready | Output | 1 | Response ready |
| o_icb_rsp_err | Input | 1 | Response error |
| o_icb_rsp_excl_ok | Input | 1 | Exclusive access ok |
| o_icb_rsp_rdata | Input | DW | Read data |
| o_icb_rsp_usr | Input | USR_W | User-defined signal |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 3. sirv_gnrl_icb_n2w

#### 3.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| X_W                | 32            | Input data width (in bits) |
| Y_W                | 64            | Output data width (in bits) |
| USR_W              | 1             | User-defined signal width |

#### 3.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_icb_cmd_valid | Input | 1 | Input command valid |
| i_icb_cmd_ready | Output | 1 | Input command ready |
| i_icb_cmd_read | Input | 1 | Read/write indicator |
| i_icb_cmd_addr | Input | AW | Command address |
| i_icb_cmd_wdata | Input | X_W | Write data |
| i_icb_cmd_wmask | Input | X_W/8 | Write mask |
| i_icb_cmd_lock | Input | 1 | Lock signal |
| i_icb_cmd_excl | Input | 1 | Exclusive access |
| i_icb_cmd_size | Input | 2 | Transfer size |
| i_icb_cmd_burst | Input | 2 | Burst type |
| i_icb_cmd_beat | Input | 2 | Beat type |
| i_icb_cmd_usr | Input | USR_W | User-defined signal |
| i_icb_rsp_valid | Output | 1 | Response valid |
| i_icb_rsp_ready | Input | 1 | Response ready |
| i_icb_rsp_err | Output | 1 | Response error |
| i_icb_rsp_excl_ok | Output | 1 | Exclusive access ok |
| i_icb_rsp_rdata | Output | X_W | Read data |
| i_icb_rsp_usr | Output | USR_W | User-defined signal |
| o_icb_cmd_valid | Output | 1 | Output command valid |
| o_icb_cmd_ready | Input | 1 | Output command ready |
| o_icb_cmd_read | Output | 1 | Read/write indicator |
| o_icb_cmd_addr | Output | AW | Command address |
| o_icb_cmd_wdata | Output | Y_W | Write data |
| o_icb_cmd_wmask | Output | Y_W/8 | Write mask |
| o_icb_cmd_lock | Output | 1 | Lock signal |
| o_icb_cmd_excl | Output | 1 | Exclusive access |
| o_icb_cmd_size | Output | 2 | Transfer size |
| o_icb_cmd_burst | Output | 2 | Burst type |
| o_icb_cmd_beat | Output | 2 | Beat type |
| o_icb_cmd_usr | Output | USR_W | User-defined signal |
| o_icb_rsp_valid | Input | 1 | Response valid |
| o_icb_rsp_ready | Output | 1 | Response ready |
| o_icb_rsp_err | Input | 1 | Response error |
| o_icb_rsp_excl_ok | Input | 1 | Exclusive access ok |
| o_icb_rsp_rdata | Input | Y_W | Read data |
| o_icb_rsp_usr | Input | USR_W | User-defined signal |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 4. sirv_gnrl_icb_splt

#### 4.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| DW                 | 64            | Data width (in bits) |
| USR_W              | 1             | User-defined signal width |
| SPLT_NUM           | 4             | Number of slave ports |
| SPLT_PTR_W         | 2             | Width of the split pointer |

#### 4.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_icb_splt_indic | Input | SPLT_NUM | Slave selection indicator |
| i_icb_cmd_valid | Input | 1 | Input command valid |
| i_icb_cmd_ready | Output | 1 | Input command ready |
| i_icb_cmd_read | Input | 1 | Read/write indicator |
| i_icb_cmd_addr | Input | AW | Command address |
| i_icb_cmd_wdata | Input | DW | Write data |
| i_icb_cmd_wmask | Input | DW/8 | Write mask |
| i_icb_cmd_burst | Input | 2 | Burst type |
| i_icb_cmd_beat | Input | 2 | Beat type |
| i_icb_cmd_lock | Input | 1 | Lock signal |
| i_icb_cmd_excl | Input | 1 | Exclusive access |
| i_icb_cmd_size | Input | 2 | Transfer size |
| i_icb_cmd_usr | Input | USR_W | User-defined signal |
| i_icb_rsp_valid | Output | 1 | Response valid |
| i_icb_rsp_ready | Input | 1 | Response ready |
| i_icb_rsp_err | Output | 1 | Response error |
| i_icb_rsp_excl_ok | Output | 1 | Exclusive access ok |
| i_icb_rsp_rdata | Output | DW | Read data |
| i_icb_rsp_usr | Output | USR_W | User-defined signal |
| o_bus_icb_cmd_ready | Input | SPLT_NUM | Command ready from slaves |
| o_bus_icb_cmd_valid | Output | SPLT_NUM | Command valid to slaves |
| o_bus_icb_cmd_read | Output | SPLT_NUM | Read/write indicators |
| o_bus_icb_cmd_addr | Output | SPLT_NUM*AW | Command addresses |
| o_bus_icb_cmd_wdata | Output | SPLT_NUM*DW | Write data |
| o_bus_icb_cmd_wmask | Output | SPLT_NUM*DW/8 | Write masks |
| o_bus_icb_cmd_burst | Output | SPLT_NUM*2 | Burst types |
| o_bus_icb_cmd_beat | Output | SPLT_NUM*2 | Beat types |
| o_bus_icb_cmd_lock | Output | SPLT_NUM | Lock signals |
| o_bus_icb_cmd_excl | Output | SPLT_NUM | Exclusive access |
| o_bus_icb_cmd_size | Output | SPLT_NUM*2 | Transfer sizes |
| o_bus_icb_cmd_usr | Output | SPLT_NUM*USR_W | User-defined signals |
| o_bus_icb_rsp_valid | Input | SPLT_NUM | Response valid from slaves |
| o_bus_icb_rsp_ready | Output | SPLT_NUM | Response ready to slaves |
| o_bus_icb_rsp_err | Input | SPLT_NUM | Response errors |
| o_bus_icb_rsp_excl_ok | Input | SPLT_NUM | Exclusive access ok |
| o_bus_icb_rsp_rdata | Input | SPLT_NUM*DW | Read data from slaves |
| o_bus_icb_rsp_usr | Input | SPLT_NUM*USR_W | User-defined signals |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 5. sirv_gnrl_icb2axi

#### 5.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| DW                 | 64            | Data width (in bits) |

#### 5.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_icb_cmd_valid | Input | 1 | ICB command valid |
| i_icb_cmd_ready | Output | 1 | ICB command ready |
| i_icb_cmd_read | Input | 1 | ICB read/write indicator |
| i_icb_cmd_addr | Input | AW | ICB command address |
| i_icb_cmd_wdata | Input | DW | ICB write data |
| i_icb_cmd_wmask | Input | DW/8 | ICB write mask |
| i_icb_cmd_size | Input | 2 | ICB transfer size |
| i_icb_rsp_valid | Output | 1 | ICB response valid |
| i_icb_rsp_ready | Input | 1 | ICB response ready |
| i_icb_rsp_err | Output | 1 | ICB response error |
| i_icb_rsp_rdata | Output | DW | ICB read data |
| o_axi_arvalid | Output | 1 | AXI read address valid |
| o_axi_arready | Input | 1 | AXI read address ready |
| o_axi_araddr | Output | AW | AXI read address |
| o_axi_arcache | Output | 4 | AXI cache type |
| o_axi_arprot | Output | 3 | AXI protection type |
| o_axi_arlock | Output | 2 | AXI lock type |
| o_axi_arburst | Output | 2 | AXI burst type |
| o_axi_arlen | Output | 4 | AXI burst length |
| o_axi_arsize | Output | 3 | AXI burst size |
| o_axi_awvalid | Output | 1 | AXI write address valid |
| o_axi_awready | Input | 1 | AXI write address ready |
| o_axi_awaddr | Output | AW | AXI write address |
| o_axi_awcache | Output | 4 | AXI cache type |
| o_axi_awprot | Output | 3 | AXI protection type |
| o_axi_awlock | Output | 2 | AXI lock type |
| o_axi_awburst | Output | 2 | AXI burst type |
| o_axi_awlen | Output | 4 | AXI burst length |
| o_axi_awsize | Output | 3 | AXI burst size |
| o_axi_rvalid | Input | 1 | AXI read data valid |
| o_axi_rready | Output | 1 | AXI read ready |
| o_axi_rdata | Input | DW | AXI read data |
| o_axi_rresp | Input | 2 | AXI read response |
| o_axi_rlast | Input | 1 | AXI read last |
| o_axi_wvalid | Output | 1 | AXI write valid |
| o_axi_wready | Input | 1 | AXI write ready |
| o_axi_wdata | Output | DW | AXI write data |
| o_axi_wstrb | Output | DW/8 | AXI write strobe |
| o_axi_wlast | Output | 1 | AXI write last |
| o_axi_bvalid | Input | 1 | AXI write response valid |
| o_axi_bready | Output | 1 | AXI write response ready |
| o_axi_bresp | Input | 2 | AXI write response |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 6. sirv_gnrl_icb32towishb8

#### 6.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |

#### 6.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_icb_cmd_valid | Input | 1 | ICB command valid |
| i_icb_cmd_ready | Output | 1 | ICB command ready |
| i_icb_cmd_read | Input | 1 | ICB read/write indicator |
| i_icb_cmd_addr | Input | AW | ICB command address |
| i_icb_cmd_wdata | Input | 32 | ICB write data |
| i_icb_cmd_wmask | Input | 4 | ICB write mask |
| i_icb_cmd_size | Input | 2 | ICB transfer size |
| i_icb_rsp_valid | Output | 1 | ICB response valid |
| i_icb_rsp_ready | Input | 1 | ICB response ready |
| i_icb_rsp_err | Output | 1 | ICB response error |
| i_icb_rsp_rdata | Output | 32 | ICB read data |
| wb_adr | Output | AW | Wishbone address |
| wb_dat_w | Output | 8 | Wishbone write data |
| wb_dat_r | Input | 8 | Wishbone read data |
| wb_we | Output | 1 | Wishbone write enable |
| wb_stb | Output | 1 | Wishbone strobe |
| wb_cyc | Output | 1 | Wishbone cycle valid |
| wb_ack | Input | 1 | Wishbone acknowledge |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 7. sirv_gnrl_icb2apb

#### 7.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| DW                 | 32            | Data width (in bits) |

#### 7.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_icb_cmd_valid | Input | 1 | ICB command valid |
| i_icb_cmd_ready | Output | 1 | ICB command ready |
| i_icb_cmd_read | Input | 1 | ICB read/write indicator |
| i_icb_cmd_addr | Input | AW | ICB command address |
| i_icb_cmd_wdata | Input | DW | ICB write data |
| i_icb_cmd_wmask | Input | DW/8 | ICB write mask |
| i_icb_cmd_size | Input | 2 | ICB transfer size |
| i_icb_rsp_valid | Output | 1 | ICB response valid |
| i_icb_rsp_ready | Input | 1 | ICB response ready |
| i_icb_rsp_err | Output | 1 | ICB response error |
| i_icb_rsp_rdata | Output | DW | ICB read data |
| apb_paddr | Output | AW | APB address |
| apb_pwrite | Output | 1 | APB write enable |
| apb_pselx | Output | 1 | APB select |
| apb_penable | Output | 1 | APB enable |
| apb_pwdata | Output | DW | APB write data |
| apb_prdata | Input | DW | APB read data |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 8. sirv_gnrl_icb2ahbl

#### 8.1 Parameter Configuration

| Parameter Name     | Default Value | Description |
|--------------------|---------------|-------------|
| AW                 | 32            | Address width (in bits) |
| DW                 | 32            | Data width (in bits) |

#### 8.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| icb_cmd_valid | Input | 1 | ICB command valid |
| icb_cmd_ready | Output | 1 | ICB command ready |
| icb_cmd_read | Input | 1 | ICB read/write indicator |
| icb_cmd_addr | Input | AW | ICB command address |
| icb_cmd_wdata | Input | DW | ICB write data |
| icb_cmd_wmask | Input | DW/8 | ICB write mask |
| icb_cmd_size | Input | 2 | ICB transfer size |
| icb_cmd_lock | Input | 1 | ICB lock signal |
| icb_cmd_excl | Input | 1 | ICB exclusive access |
| icb_cmd_burst | Input | 2 | ICB burst type |
| icb_cmd_beat | Input | 2 | ICB beat type |
| icb_rsp_valid | Output | 1 | ICB response valid |
| icb_rsp_ready | Input | 1 | ICB response ready |
| icb_rsp_err | Output | 1 | ICB response error |
| icb_rsp_excl_ok | Output | 1 | ICB exclusive access ok |
| icb_rsp_rdata | Output | DW | ICB read data |
| ahbl_htrans | Output | 2 | AHB transfer type |
| ahbl_hwrite | Output | 1 | AHB write indicator |
| ahbl_haddr | Output | AW | AHB address |
| ahbl_hsize | Output | 3 | AHB transfer size |
| ahbl_hlock | Output | 1 | AHB lock signal |
| ahbl_hexcl | Output | 1 | AHB exclusive access |
| ahbl_hburst | Output | 3 | AHB burst type |
| ahbl_hwdata | Output | DW | AHB write data |
| ahbl_hprot | Output | 4 | AHB protection control |
| ahbl_hattri | Output | 2 | AHB attributes |
| ahbl_master | Output | 2 | AHB master indicator |
| ahbl_hrdata | Input | DW | AHB read data |
| ahbl_hresp | Input | 2 | AHB response |
| ahbl_hresp_exok | Input | 1 | AHB exclusive ok |
| ahbl_hready | Input | 1 | AHB ready |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |

### 9. sirv_gnrl_axi_buffer

#### 9.1 Parameter Configuration

| Parameter Name         | Default Value | Description |
|------------------------|---------------|-------------|
| CHNL_FIFO_DP           | 2             | Depth of the channel FIFO |
| CHNL_FIFO_CUT_READY    | 2             | Controls whether the ready signal is cut in the channel FIFO |
| AW                     | 32            | Address width (in bits) |
| DW                     | 32            | Data width (in bits) |

#### 9.2 Signal Interface

| Port Name | Direction | Width | Description |
|-----------|-----------|-------|-------------|
| i_axi_arvalid | Input | 1 | Input AXI read address valid |
| i_axi_arready | Output | 1 | Input AXI read address ready |
| i_axi_araddr | Input | AW | Input AXI read address |
| i_axi_arcache | Input | 4 | Input AXI read cache type |
| i_axi_arprot | Input | 3 | Input AXI read protection |
| i_axi_arlock | Input | 2 | Input AXI read lock |
| i_axi_arburst | Input | 2 | Input AXI read burst type |
| i_axi_arlen | Input | 4 | Input AXI read burst length |
| i_axi_arsize | Input | 3 | Input AXI read transfer size |
| i_axi_awvalid | Input | 1 | Input AXI write address valid |
| i_axi_awready | Output | 1 | Input AXI write address ready |
| i_axi_awaddr | Input | AW | Input AXI write address |
| i_axi_awcache | Input | 4 | Input AXI write cache type |
| i_axi_awprot | Input | 3 | Input AXI write protection |
| i_axi_awlock | Input | 2 | Input AXI write lock |
| i_axi_awburst | Input | 2 | Input AXI write burst type |
| i_axi_awlen | Input | 4 | Input AXI write burst length |
| i_axi_awsize | Input | 3 | Input AXI write transfer size |
| i_axi_rvalid | Output | 1 | Input AXI read data valid |
| i_axi_rready | Input | 1 | Input AXI read ready |
| i_axi_rdata | Output | DW | Input AXI read data |
| i_axi_rresp | Output | 2 | Input AXI read response |
| i_axi_rlast | Output | 1 | Input AXI read last |
| i_axi_wvalid | Input | 1 | Input AXI write valid |
| i_axi_wready | Output | 1 | Input AXI write ready |
| i_axi_wdata | Input | DW | Input AXI write data |
| i_axi_wstrb | Input | DW/8 | Input AXI write strobe |
| i_axi_wlast | Input | 1 | Input AXI write last |
| i_axi_bvalid | Output | 1 | Input AXI write response valid |
| i_axi_bready | Input | 1 | Input AXI write response ready |
| i_axi_bresp | Output | 2 | Input AXI write response |
| o_axi_arvalid | Output | 1 | Output AXI read address valid |
| o_axi_arready | Input | 1 | Output AXI read address ready |
| o_axi_araddr | Output | AW | Output AXI read address |
| o_axi_arcache | Output | 4 | Output AXI read cache type |
| o_axi_arprot | Output | 3 | Output AXI read protection |
| o_axi_arlock | Output | 2 | Output AXI read lock |
| o_axi_arburst | Output | 2 | Output AXI read burst type |
| o_axi_arlen | Output | 4 | Output AXI read burst length |
| o_axi_arsize | Output | 3 | Output AXI read transfer size |
| o_axi_awvalid | Output | 1 | Output AXI write address valid |
| o_axi_awready | Input | 1 | Output AXI write address ready |
| o_axi_awaddr | Output | AW | Output AXI write address |
| o_axi_awcache | Output | 4 | Output AXI write cache type |
| o_axi_awprot | Output | 3 | Output AXI write protection |
| o_axi_awlock | Output | 2 | Output AXI write lock |
| o_axi_awburst | Output | 2 | Output AXI write burst type |
| o_axi_awlen | Output | 4 | Output AXI write burst length |
| o_axi_awsize | Output | 3 | Output AXI write transfer size |
| o_axi_rvalid | Input | 1 | Output AXI read data valid |
| o_axi_rready | Output | 1 | Output AXI read ready |
| o_axi_rdata | Input | DW | Output AXI read data |
| o_axi_rresp | Input | 2 | Output AXI read response |
| o_axi_rlast | Input | 1 | Output AXI read last |
| o_axi_wvalid | Output | 1 | Output AXI write valid |
| o_axi_wready | Input | 1 | Output AXI write ready |
| o_axi_wdata | Output | DW | Output AXI write data |
| o_axi_wstrb | Output | DW/8 | Output AXI write strobe |
| o_axi_wlast | Output | 1 | Output AXI write last |
| o_axi_bvalid | Input | 1 | Output AXI write response valid |
| o_axi_bready | Output | 1 | Output AXI write response ready |
| o_axi_bresp | Input | 2 | Output AXI write response |
| clk | Input | 1 | Clock |
| rst_n | Input | 1 | Reset (active low) |
