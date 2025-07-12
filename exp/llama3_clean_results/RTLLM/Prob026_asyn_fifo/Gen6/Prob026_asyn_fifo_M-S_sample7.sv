module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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

// Dual-port RAM
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write and read pointers
reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] rptr_bin;

// Synchronized pointers
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] rptr_sync;

// Gray code conversion
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= wptr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= rptr_bin + 1;
    end
end

// Pointer synchronization
always @(posedge rclk) begin
    wptr_sync <= wptr_bin;
end

always @(posedge wclk) begin
    rptr_sync <= rptr_bin;
end

// Full and empty conditions
assign wfull = (wptr_bin == (rptr_bin + 1));
assign rempty = (rptr_bin == wptr_bin);

// Write and read operations
always @(posedge wclk) begin
    if (~wrstn && winc && ~wfull) begin
        RAM_MEM[wptr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn && rinc && ~rempty) begin
        rdata <= RAM_MEM[rptr_bin];
    end
end

endmodule