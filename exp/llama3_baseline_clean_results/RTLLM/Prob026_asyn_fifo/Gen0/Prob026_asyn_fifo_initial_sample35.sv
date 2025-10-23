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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

// Dual-port RAM
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
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule

// Write and Read Controllers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray Code Conversion
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;

always @(posedge wclk) begin
    wptr <= waddr_bin[2:0] ^ (waddr_bin[2:0] >> 1);
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr <= raddr_bin[2:0] ^ (raddr_bin[2:0] >> 1);
    rptr_buff <= rptr;
end

// Pointer Synchronizers
reg [3:0] rptr_syn;
reg [3:0] wptr_syn;

always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

always @(posedge rclk) begin
    wptr_syn <= wptr_buff;
end

// Full and Empty Signals
assign wfull = (wptr == (~rptr_syn[3] & rptr_syn[2:0]));
assign rempty = (rptr == wptr);

// Input and Output Connections
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin[2:0]),
    .rdata(rdata)
);

endmodule