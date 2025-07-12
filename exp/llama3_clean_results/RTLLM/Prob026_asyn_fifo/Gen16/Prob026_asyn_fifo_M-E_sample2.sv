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

reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] rptr_bin;

reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;

reg [WIDTH-1:0] ram[DEPTH-1:0];

// Dual-port RAM module
always @(posedge wclk) begin
    if (winc) begin
        ram[wptr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata <= ram[rptr_bin];
end

// Write pointer management
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

// Read pointer management
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr_gray <= (wptr_bin >> 1) ^ wptr_bin;
end

always @(posedge rclk) begin
    rptr_gray <= (rptr_bin >> 1) ^ rptr_bin;
end

// Full and empty signal generation
assign wfull = (wptr_gray == (rptr_gray + 1) % (1 << (ADDR_WIDTH - 1)));
assign rempty = (rptr_gray == wptr_gray);

endmodule