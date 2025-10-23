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

reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;

reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;

// Dual-port RAM module
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_bin),
    .rdata(rdata)
);

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

// Two-stage trigger for pointer synchronization
always @(posedge wclk) begin
    wptr_sync1 <= rptr_bin;
end

always @(posedge rclk) begin
    rptr_sync1 <= wptr_bin;
end

always @(posedge wclk) begin
    wptr_sync2 <= wptr_sync1;
end

always @(posedge rclk) begin
    rptr_sync2 <= rptr_sync1;
end

// Full and empty signal generation
assign wfull = (wptr_gray == ((rptr_sync2 + 1) % (1 << (ADDR_WIDTH - 1))));
assign rempty = (rptr_gray == wptr_gray);

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] ram[DEPTH-1:0];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

endmodule