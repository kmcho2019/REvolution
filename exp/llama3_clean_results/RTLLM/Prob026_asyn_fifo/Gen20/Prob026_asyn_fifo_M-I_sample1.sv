// Improved Version of the Asynchronous FIFO

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

// Corrected Dual-port RAM module instantiation
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr_bin[ADDR_WIDTH-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_bin[ADDR_WIDTH-2:0]),
    .rdata(rdata)
);

// Write pointer management with correct reset
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

// Read pointer management with correct reset
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

// Correct Gray code conversion
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

// Full and empty signal generation with corrected logic
assign wfull = (wptr_gray[ADDR_WIDTH-1] != rptr_sync2[ADDR_WIDTH-1]) && (wptr_gray[ADDR_WIDTH-2:0] == rptr_sync2[ADDR_WIDTH-2:0]);
assign rempty = (rptr_gray == wptr_gray);

endmodule

// Dual-port RAM module definition (outside asyn_fifo for correctness)
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

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