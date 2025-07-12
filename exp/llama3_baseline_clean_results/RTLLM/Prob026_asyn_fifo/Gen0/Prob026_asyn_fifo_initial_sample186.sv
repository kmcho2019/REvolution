// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

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

// Asynchronous FIFO module
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

// Instantiate dual-port RAM module
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_syn;
reg [3:0] rptr_syn;

always @(posedge wclk) begin
    wptr <= waddr_bin[1:0] ^ (waddr_bin[2:0] >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin[1:0] ^ (raddr_bin[2:0] >> 1);
end

// Pointer synchronizers
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_syn <= wptr_buff;
    rptr_buff <= rptr;
end

// Full and empty signals
assign wfull = (wptr_syn == {~rptr[3], rptr[2:0]}) ? 1 : 0;
assign rempty = (rptr == wptr_syn) ? 1 : 0;

// Control signals
assign wenc = winc ? 1 : 0;
assign renc = rinc ? 1 : 0;

endmodule