# Descrition sd_defines.v

This file describes some macro definitions related to the SDC IP Core operation. Before starting to build the core, the sd_defines.v should be setup properly. The available options that can be modified are.:

| Name                 | Valid Values                 | Description                              |
|----------------------|------------------------------|------------------------------------------|
| BIG_ENDIAN           |             | Big Endian System |
| LITTLE_ENDIAN        |          | Little Endian System |
| SIM                  |                              | To ease up simulation                    |
| SYN                  |                              | For Synthesizing                         |
| SDC_IRQ_ENABLE       |                              | Three extra Interrupt pin will be added  |
| ACTEL                |                              | Get some predefine settings              |
| BD_WIDTH             | <= 8                         | $\log_2{BD-SIZE}$                           |
| BD_SIZE              | <= 255                      | Size of the BD buffer                    |
| RAM_MEM_WIDTH_16     |                              | Width of block Ram == 16                 |
| RAM_MEM_WIDTH        | 16, 32                       | Width of block Ram                       |
| RESEND_MAX_CNT       | < 255                       | How many retry to resend data            |
| MEM_OFFSET           |                              | Memory address offset between 2 words    |
| RESET_CLK_DIV        | < 255                       | In clock divider                         |
| SD_CLK_BUS_CLK       |                              | Use the same clock as the WB-Bus        |
| SD_CLK_SEP           |                              | Use sd_clk_i_pad as SD CLK              |
| SD_CLK_STATIC        |                              | SD CLK = IN clock                       |
| SD_CLK_DYNAMIC       |                              | SD CLK = CLK from ClkDivider             |
| BLOCK_SIZE           | 512                          | Block Size                               |
| SD_BUS_WIDTH_4       |                              | Only support for 4 Bit                   |
| SD_BUS_W             | 4                            | Only support for 4 Bit                   |
| FIFO_RX_MEM_DEPTH    |                              | Width of RX Fifo                        |
| FIFO_RX_MEM_ADR_SIZE |  | $\log_2{FIFO\_RX\_MEM\_DEPTH}$ +1 |
| FIFO_TX_MEM_DEPTH    |                              | Width of TX Fifo                        |
| FIFO_TX_MEM_ADR_SIZE |              | $\log_2{FIFO\_TX\_MEM\_DEPTH}$ +1 |

Table 1: Core define options
