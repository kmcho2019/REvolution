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
    output wire wfull,   // FIFO full flag
    output wire rempty,  // FIFO empty flag
    output reg [WIDTH-1:0] rdata  // Read data
);

    localparam ADDR_WIDTH = $clog2(DEPTH);
    localparam PTR_WIDTH = ADDR_WIDTH + 1;  // Extra bit for full/empty detection
    
    // Dual-port memory
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Gray code conversion function
    function [PTR_WIDTH-1:0] bin2gray;
        input [PTR_WIDTH-1:0] bin;
        bin2gray = bin ^ (bin >> 1);
    endfunction
    
    // Write domain signals
    reg [PTR_WIDTH-1:0] wptr_bin = 0;      // Binary write pointer
    wire [PTR_WIDTH-1:0] wptr_gray = bin2gray(wptr_bin); // Gray code write pointer
    
    // Read domain signals
    reg [PTR_WIDTH-1:0] rptr_bin = 0;      // Binary read pointer
    wire [PTR_WIDTH-1:0] rptr_gray = bin2gray(rptr_bin); // Gray code read pointer
    
    // Synchronizers
    reg [PTR_WIDTH-1:0] rptr_gray_sync0 = 0;
    reg [PTR_WIDTH-1:0] rptr_gray_sync1 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync0 = 0;
    reg [PTR_WIDTH-1:0] wptr_gray_sync1 = 0;
    
    // Write pointer update
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            wptr_bin <= 0;
        end else if (winc && !wfull) begin
            wptr_bin <= wptr_bin + 1;
            mem[wptr_bin[ADDR_WIDTH-1:0]] <= wdata;
        end
    end
    
    // Read pointer update
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            rptr_bin <= 0;
            rdata <= 0;
        end else if (rinc && !rempty) begin
            rptr_bin <= rptr_bin + 1;
            rdata <= mem[rptr_bin[ADDR_WIDTH-1:0]];
        end
    end
    
    // Read pointer synchronization (write clock domain)
    always @(posedge wclk or negedge wrstn) begin
        if (!wrstn) begin
            rptr_gray_sync0 <= 0;
            rptr_gray_sync1 <= 0;
        end else begin
            rptr_gray_sync0 <= rptr_gray;
            rptr_gray_sync1 <= rptr_gray_sync0;
        end
    end
    
    // Write pointer synchronization (read clock domain)
    always @(posedge rclk or negedge rrstn) begin
        if (!rrstn) begin
            wptr_gray_sync0 <= 0;
            wptr_gray_sync1 <= 0;
        end else begin
            wptr_gray_sync0 <= wptr_gray;
            wptr_gray_sync1 <= wptr_gray_sync0;
        end
    end
    
    // Flag generation
    assign wfull = ((wptr_gray[PTR_WIDTH-1] != rptr_gray_sync1[PTR_WIDTH-1]) &&
                  (wptr_gray[PTR_WIDTH-2] != rptr_gray_sync1[PTR_WIDTH-2]) &&
                  (wptr_gray[PTR_WIDTH-3:0] == rptr_gray_sync1[PTR_WIDTH-3:0]));
    
    assign rempty = (rptr_gray == wptr_gray_sync1);

endmodule