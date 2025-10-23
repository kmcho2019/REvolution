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

// Dual-Port RAM (DPRAM) submodule
reg [WIDTH-1:0] dpram [DEPTH-1:0];

// Write and read pointers in binary
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

// Write and read pointers in Gray code
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Two-stage synchronizers for write and read pointers
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] wptr_sync2;
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;

// Gray code conversion
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= waddr_bin + 1;
    end
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= raddr_bin + 1;
    end
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Two-stage synchronizers
always @(posedge rclk) begin
    wptr_sync1 <= wptr;
    wptr_sync2 <= wptr_sync1;
end

always @(posedge wclk) begin
    rptr_sync1 <= rptr;
    rptr_sync2 <= rptr_sync1;
end

// Full and empty signals
assign wfull = (wptr_sync[ADDR_WIDTH-1] != rptr[ADDR_WIDTH-1]) && (wptr_sync2[ADDR_WIDTH] != rptr[ADDR_WIDTH-2]) && (wptr_sync2[ADDR_WIDTH-3:0] == rptr[ADDR_WIDTH-3:0]);
assign rempty = (rptr == wptr_sync2);

// Write operation
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        dpram[waddr_bin] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= dpram[raddr_bin];
    end
end

endmodule