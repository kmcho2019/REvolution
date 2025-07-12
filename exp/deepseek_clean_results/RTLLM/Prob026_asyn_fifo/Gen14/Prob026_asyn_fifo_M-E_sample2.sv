module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output [WIDTH-1:0] rdata
);

    // Validate DEPTH is power of 2 and >= 4
    initial begin
        if ((DEPTH & (DEPTH-1)) != 0) $error("DEPTH must be power of 2");
        if (DEPTH < 4) $error("DEPTH must be >= 4");
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    localparam BANK_COUNT = 2;  // Memory banking factor

    // ========== Memory Bank Implementation ==========
    reg [WIDTH-1:0] mem_bank0 [0:DEPTH/BANK_COUNT-1];
    reg [WIDTH-1:0] mem_bank1 [0:DEPTH/BANK_COUNT-1];
    
    wire [ADDR_WIDTH-1:0] waddr = wptr_bin[ADDR_WIDTH-1:0];
    wire [ADDR_WIDTH-1:0] raddr = rptr_bin[ADDR_WIDTH-1:0];
    wire bank_sel_w = waddr[ADDR_WIDTH-1];
    wire bank_sel_r = raddr[ADDR_WIDTH-1];

    // Write to appropriate bank
    always @(posedge wclk) begin
        if (wen) begin
            if (!bank_sel_w) mem_bank0[waddr[ADDR_WIDTH-2:0]] <= wdata;
            else mem_bank1[waddr[ADDR_WIDTH-2:0]] <= wdata;
        end
    end

    // Read from appropriate bank
    reg [WIDTH-1:0] rdata_reg;
    always @(posedge rclk) begin
        if (ren) begin
            if (!bank_sel_r) rdata_reg <= mem_bank0[raddr[ADDR_WIDTH-2:0]];
            else rdata_reg <= mem_bank1[raddr[ADDR_WIDTH-2:0]];
        end
    end
    assign rdata = rdata_reg;

    // ========== Write Domain ==========
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_next_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_sync [0:1];
    reg rptr_meta_stable = 0;

    wire wen = winc && !wfull && !rptr_meta_stable;

    // Pointer management with next-state prediction
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
            wptr_next_gray <= 1;
        end else if (wen) begin
            wptr_bin <= wptr_bin + 1;
            wptr_gray <= wptr_next_gray;
            wptr_next_gray <= (wptr_bin + 2) ^ ((wptr_bin + 2) >> 1);
        end
    end

    // Synchronizer with metastability detection
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_sync[0] <= 0;
            rptr_sync[1] <= 0;
            rptr_meta_stable <= 0;
        end else begin
            rptr_sync[0] <= rptr_gray;
            rptr_sync[1] <= rptr_sync[0];
            rptr_meta_stable <= (rptr_sync[0] ^ rptr_sync[1]) != 0;
        end
    end

    // ========== Read Domain ==========
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    reg [PTR_WIDTH-1:0] rptr_next_gray = 0;
    reg [PTR_WIDTH-1:0] wptr_sync [0:1];
    reg wptr_meta_stable = 0;

    wire ren = rinc && !rempty && !wptr_meta_stable;

    // Pointer management with next-state prediction
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rptr_next_gray <= 1;
        end else if (ren) begin
            rptr_bin <= rptr_bin + 1;
            rptr_gray <= rptr_next_gray;
            rptr_next_gray <= (rptr_bin + 2) ^ ((rptr_bin + 2) >> 1);
        end
    end

    // Synchronizer with metastability detection
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_sync[0] <= 0;
            wptr_sync[1] <= 0;
            wptr_meta_stable <= 0;
        end else begin
            wptr_sync[0] <= wptr_gray;
            wptr_sync[1] <= wptr_sync[0];
            wptr_meta_stable <= (wptr_sync[0] ^ wptr_sync[1]) != 0;
        end
    end

    // ========== Adaptive Threshold Control ==========
    reg [1:0] wclk_div = 0;
    reg [1:0] rclk_div = 0;
    wire wclk_slow = (wclk_div == 2'b11);
    wire rclk_slow = (rclk_div == 2'b11);

    always @(posedge wclk) wclk_div <= wclk_div + 1;
    always @(posedge rclk) rclk_div <= rclk_div + 1;

    // ========== Status Generation ==========
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            // Adaptive threshold based on clock ratio
            if (wclk_slow && !rclk_slow)
                wfull <= (wptr_gray == {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                         rptr_sync[1][PTR_WIDTH-3:0]});
            else
                wfull <= (wptr_next_gray == {~rptr_sync[1][PTR_WIDTH-1:PTR_WIDTH-2], 
                           rptr_sync[1][PTR_WIDTH-3:0]});
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            // Adaptive threshold based on clock ratio
            if (rclk_slow && !wclk_slow)
                rempty <= (rptr_gray == wptr_sync[1]);
            else
                rempty <= (rptr_next_gray == wptr_sync[1]);
        end
    end

endmodule