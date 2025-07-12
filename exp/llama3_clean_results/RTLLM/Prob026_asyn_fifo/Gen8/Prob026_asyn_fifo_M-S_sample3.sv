// Dual-Port RAM Module
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

reg [WIDTH-1:0] ram [DEPTH-1:0];

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

// Asynchronous FIFO Module
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

reg [ADDR_WIDTH-1:0] wptr_bin, rptr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray, rptr_gray;

// Write Pointer Synchronizer
reg [ADDR_WIDTH-1:0] wptr_syn;
always @(posedge rclk) begin
    wptr_syn <= wptr_gray;
end

// Read Pointer Synchronizer
reg [ADDR_WIDTH-1:0] rptr_syn;
always @(posedge wclk) begin
    rptr_syn <= rptr_gray;
end

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
    end else if (winc) begin
        wptr_bin <= wptr_bin + 1;
        wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
    end else if (rinc) begin
        rptr_bin <= rptr_bin + 1;
        rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
    end
end

// Full and Empty Signal Generation
assign wfull = (wptr_gray == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});
assign rempty = (rptr_gray == wptr_syn);

// Dual-Port RAM Instantiation
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr_bin[ADDR_WIDTH-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_bin[ADDR_WIDTH-2:0]),
    .rdata(rdata)
);

endmodule