module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
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

localparam ADDR_WIDTH = $clog2(DEPTH);

// Single-port RAM for ring buffer
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write pointer
reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;

// Read pointer
reg [ADDR_WIDTH-1:0] rptr_bin;
reg [ADDR_WIDTH-1:0] rptr_gray;

// Synchronized read pointer for write clock domain
reg [ADDR_WIDTH-1:0] rptr_syn;

// Synchronized write pointer for read clock domain
reg [ADDR_WIDTH-1:0] wptr_syn;

// Full and empty signals
reg full;
reg empty;

// Write operation
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc & ~wfull) begin
        wptr_bin <= wptr_bin + 1;
        RAM_MEM[wptr_bin] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc & ~rempty) begin
        rptr_bin <= rptr_bin + 1;
        rdata <= RAM_MEM[rptr_bin];
    end
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
end

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
end

// Synchronize read pointer for write clock domain
always @(posedge wclk) begin
    rptr_syn <= rptr_gray;
end

// Synchronize write pointer for read clock domain
always @(posedge rclk) begin
    wptr_syn <= wptr_gray;
end

// Full and empty detection
always @(posedge wclk) begin
    full <= (wptr_gray == (rptr_syn + 1));
end

always @(posedge rclk) begin
    empty <= (rptr_gray == wptr_syn);
end

// Output signals
assign wfull = full;
assign rempty = empty;

endmodule