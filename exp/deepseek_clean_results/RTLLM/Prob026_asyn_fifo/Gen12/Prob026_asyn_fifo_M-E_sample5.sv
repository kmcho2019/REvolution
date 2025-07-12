module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter MAX_SYNC_STAGES = 4
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

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain
    reg [PTR_WIDTH-1:0] wptr_bin = 0;
    reg [PTR_WIDTH-1:0] wptr_gray = 0;
    wire [PTR_WIDTH-1:0] wptr_next = wptr_bin + 1;
    wire [PTR_WIDTH-1:0] wptr_gray_next = wptr_next ^ (wptr_next >> 1);
    
    // Read domain
    reg [PTR_WIDTH-1:0] rptr_bin = 0;
    reg [PTR_WIDTH-1:0] rptr_gray = 0;
    wire [PTR_WIDTH-1:0] rptr_next = rptr_bin + 1;
    wire [PTR_WIDTH-1:0] rptr_gray_next = rptr_next ^ (rptr_next >> 1);
    
    // Synchronization chains
    reg [PTR_WIDTH-1:0] sync_r2w [0:MAX_SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] sync_w2r [0:MAX_SYNC_STAGES-1];
    reg [2:0] sync_stages = 3; // Default 3-stage sync
    
    // Clock ratio detection
    reg [15:0] wclk_cnt = 0;
    reg [15:0] rclk_cnt = 0;
    always @(posedge wclk) wclk_cnt <= wclk_cnt + 1;
    always @(posedge rclk) rclk_cnt <= rclk_cnt + 1;
    
    // Adaptive synchronization
    always @* begin
        if (wclk_cnt > (rclk_cnt << 1)) 
            sync_stages = 4; // Fast write clock
        else if (rclk_cnt > (wclk_cnt << 1))
            sync_stages = 4; // Fast read clock
        else
            sync_stages = 3; // Similar clocks
    end
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_next;
            wptr_gray <= wptr_gray_next;
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Read data output
    reg [WIDTH-1:0] rdata_reg;
    assign rdata = rdata_reg;
    always @(posedge rclk) begin
        if (rinc && !rempty)
            rdata_reg <= mem[rptr_bin[ADDR_WIDTH-1:0]];
    end
    
    // Write domain synchronization
    integer i;
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (i = 0; i < MAX_SYNC_STAGES; i = i+1)
                sync_r2w[i] <= 0;
        end else begin
            sync_r2w[0] <= rptr_gray;
            for (i = 1; i < sync_stages; i = i+1)
                sync_r2w[i] <= sync_r2w[i-1];
        end
    end
    
    // Read domain synchronization
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (i = 0; i < MAX_SYNC_STAGES; i = i+1)
                sync_w2r[i] <= 0;
        end else begin
            sync_w2r[0] <= wptr_gray;
            for (i = 1; i < sync_stages; i = i+1)
                sync_w2r[i] <= sync_w2r[i-1];
        end
    end
    
    // Predictive full/empty detection
    wire [PTR_WIDTH-1:0] wptr_gray_synced = sync_w2r[sync_stages-1];
    wire [PTR_WIDTH-1:0] rptr_gray_synced = sync_r2w[sync_stages-1];
    
    // Full condition: next write will make pointers equal (with wrap)
    wire next_wfull = (wptr_gray_next == {~rptr_gray_synced[PTR_WIDTH-1:PTR_WIDTH-2], 
                                        rptr_gray_synced[PTR_WIDTH-3:0]});
    
    // Empty condition: next read will make pointers equal
    wire next_rempty = (rptr_gray_next == wptr_gray_synced);
    
    // Current full/empty
    wire curr_wfull = (wptr_gray == {~rptr_gray_synced[PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_gray_synced[PTR_WIDTH-3:0]});
    wire curr_rempty = (rptr_gray == wptr_gray_synced);
    
    // Update flags with predictive information
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn)
            wfull <= 0;
        else
            wfull <= curr_wfull || (winc && next_wfull);
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn)
            rempty <= 1;
        else
            rempty <= curr_rempty || (rinc && next_rempty);
    end
    
    // Error detection
    wire sync_error = (sync_r2w[0] ^ sync_r2w[sync_stages-1]) != 0 ||
                     (sync_w2r[0] ^ sync_w2r[sync_stages-1]) != 0;
    
endmodule