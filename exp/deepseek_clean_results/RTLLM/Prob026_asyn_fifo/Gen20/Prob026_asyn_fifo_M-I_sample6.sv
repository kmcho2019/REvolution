module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16,
    parameter SYNC_STAGES = 2
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
    output reg [WIDTH-1:0] rdata
);

    // Validate DEPTH is power of 2
    initial begin
        if ((DEPTH & (DEPTH - 1)) != 0) begin
            $error("DEPTH must be power of 2");
            $finish;
        end
    end

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;
    
    // Memory array
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin, wptr_gray;
    wire [PTR_WIDTH-1:0] wptr_bin_next = wptr_bin + (winc && !wfull);
    wire [PTR_WIDTH-1:0] wptr_gray_next = (wptr_bin_next >> 1) ^ wptr_bin_next;
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin, rptr_gray;
    wire [PTR_WIDTH-1:0] rptr_bin_next = rptr_bin + (rinc && !rempty);
    wire [PTR_WIDTH-1:0] rptr_gray_next = (rptr_bin_next >> 1) ^ rptr_bin_next;
    
    // Synchronized pointers
    reg [PTR_WIDTH-1:0] rptr_gray_sync [0:SYNC_STAGES-1];
    reg [PTR_WIDTH-1:0] wptr_gray_sync [0:SYNC_STAGES-1];
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin_next;
            wptr_gray <= wptr_gray_next;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin_next;
            rptr_gray <= rptr_gray_next;
        end
    end
    
    // Pointer synchronizers
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            for (int i = 0; i < SYNC_STAGES; i++)
                rptr_gray_sync[i] <= 0;
        end else begin
            rptr_gray_sync[0] <= rptr_gray;
            for (int i = 1; i < SYNC_STAGES; i++)
                rptr_gray_sync[i] <= rptr_gray_sync[i-1];
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            for (int i = 0; i < SYNC_STAGES; i++)
                wptr_gray_sync[i] <= 0;
        end else begin
            wptr_gray_sync[0] <= wptr_gray;
            for (int i = 1; i < SYNC_STAGES; i++)
                wptr_gray_sync[i] <= wptr_gray_sync[i-1];
        end
    end
    
    // Memory write operation
    always @(posedge wclk) begin
        if (winc && !wfull) begin
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Memory read operation
    always @(posedge rclk) begin
        if (rinc && !rempty) begin
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end
    
    // Flag generation (registered for better timing)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end else begin
            wfull <= (wptr_gray == {~rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-1:PTR_WIDTH-2], 
                                   rptr_gray_sync[SYNC_STAGES-1][PTR_WIDTH-3:0]});
        end
    end
    
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end else begin
            rempty <= (rptr_gray == wptr_gray_sync[SYNC_STAGES-1]);
        end
    end

endmodule