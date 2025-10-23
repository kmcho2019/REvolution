module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [WIDTH-1:0] wdata,
    input [$clog2(DEPTH)-1:0] waddr,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram[DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

endmodule

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

reg [ADDR_WIDTH-1:0] wptr_gray_sync1;
reg [ADDR_WIDTH-1:0] wptr_gray_sync2;

reg [ADDR_WIDTH-1:0] rptr_gray_sync1;
reg [ADDR_WIDTH-1:0] rptr_gray_sync2;

// Dual-port RAM module instantiation
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_module(
    .wclk(wclk),
    .wenc(winc),
    .wdata(wdata),
    .waddr(wptr_bin[ADDR_WIDTH-2:0]),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_bin[ADDR_WIDTH-2:0]),
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

// Two-stage trigger for write pointer synchronization
always @(posedge rclk) begin
    wptr_gray_sync1 <= wptr_gray;
end

always @(posedge rclk) begin
    wptr_gray_sync2 <= wptr_gray_sync1;
end

// Two-stage trigger for read pointer synchronization
always @(posedge wclk) begin
    rptr_gray_sync1 <= rptr_gray;
end

always @(posedge wclk) begin
    rptr_gray_sync2 <= rptr_gray_sync1;
end

// Full and empty signal generation
assign wfull = (wptr_gray_sync2[ADDR_WIDTH-1] != rptr_gray[ADDR_WIDTH-1]) && (wptr_gray_sync2[ADDR_WIDTH-2:0] == rptr_gray[ADDR_WIDTH-2:0]);
assign rempty = (rptr_gray == wptr_gray_sync2);

endmodule