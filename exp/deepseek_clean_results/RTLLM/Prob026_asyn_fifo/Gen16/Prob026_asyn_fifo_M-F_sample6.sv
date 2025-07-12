module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,          // Write clock
    input rclk,          // Read clock
    input wrstn,         // Write domain reset (active low)
    input rrstn,         // Read domain reset (active low)
    input winc,          // Write increment
    input rinc,          // Read increment
    input [WIDTH-1:0] wdata,  // Write data
    output reg wfull,    // FIFO full flag
    output reg rempty,   // FIFO empty flag
    output reg [WIDTH-1:0] rdata  // Read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Extra bit for full/empty detection
    
    // Dual-port memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;      // Binary write pointer
    reg [PTR_WIDTH-1:0] wptr_gray = 0;     // Gray code write pointer
    reg [PTR_WIDTH-1:0] rptr_gray_sync0 = 0;  // Synchronizer stage 1
    reg [PTR_WIDTH-1:0] rptr_gray_sync1 = 0;  // Synchronizer stage 2
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;      // Binary read pointer
    reg [PTR_WIDTH-1:0] rptr_gray = 0;     // Gray code read pointer
    reg [PTR_WIDTH-1:0] wptr_gray_sync0 = 0;  // Synchronizer stage 1
    reg [PTR_WIDTH-1:0] wptr_gray_sync1 = 0;  // Synchronizer stage 2
    
    // Write pointer control
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
            wptr_gray <= 0;
        end
        else if (winc && !wfull) begin
            // Update binary pointer
            wptr_bin <= wptr_bin + 1;
            // Convert to Gray code
            wptr_gray <= (wptr_bin + 1) ^ ((wptr_bin + 1) >> 1);
            // Write to memory
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Read pointer control
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rptr_gray <= 0;
            rdata <= 0;
        end
        else if (rinc && !rempty) begin
            // Update binary pointer
            rptr_bin <= rptr_bin + 1;
            // Convert to Gray code
            rptr_gray <= (rptr_bin + 1) ^ ((rptr_bin + 1) >> 1;
            // Read from memory
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end
    
    // Synchronize read pointer to write clock domain
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync0 <= 0;
            rptr_gray_sync1 <= 0;
        end
        else begin
            rptr_gray_sync0 <= rptr_gray;
            rptr_gray_sync1 <= rptr_gray_sync0;
        end
    end
    
    // Synchronize write pointer to read clock domain
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync0 <= 0;
            wptr_gray_sync1 <= 0;
        end
        else begin
            wptr_gray_sync0 <= wptr_gray;
            wptr_gray_sync1 <= wptr_gray_sync0;
        end
    end
    
    // Full flag generation (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wfull <= 0;
        end
        else begin
            wfull <= ((wptr_gray[PTR_WIDTH-1] != rptr_gray_sync1[PTR_WIDTH-1]) &&
                     (wptr_gray[PTR_WIDTH-2] != rptr_gray_sync1[PTR_WIDTH-2]) &&
                     (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync1[PTR_WIDTH-3:0]);
        end
    end
    
    // Empty flag generation (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rempty <= 1;
        end
        else begin
            rempty <= (rptr_gray == wptr_gray_sync1);
        end
    end

endmodule