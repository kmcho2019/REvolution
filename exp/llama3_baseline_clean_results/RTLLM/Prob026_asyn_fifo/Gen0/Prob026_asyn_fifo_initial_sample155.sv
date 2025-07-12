// Dual-port RAM module
module dual_port_RAM (
    input wclk, wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk, renc,
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

// Asynchronous FIFO module
module asyn_fifo (
    input wclk, rclk,
    input wrstn, rrstn,
    input winc, rinc,
    input [WIDTH-1:0] wdata,
    output wfull, rempty,
    output [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

wire wen, ren;
reg [WIDTH-1:0] RAM_rdata;

reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr, rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Dual-port RAM instantiation
dual_port_RAM RAM (
    .wclk(wclk), .wenc(wen), .waddr(waddr_bin), .wdata(wdata),
    .rclk(rclk), .renc(ren), .raddr(raddr_bin), .rdata(RAM_rdata)
);

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end
    else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end
    else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr <= (waddr_bin >> 1) ^ waddr_bin;
end

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr <= (raddr_bin >> 1) ^ raddr_bin;
end

// Write pointer buffer
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end
    else begin
        wptr_buff <= wptr;
    end
end

// Read pointer buffer
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end
    else begin
        rptr_buff <= rptr;
    end
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Full and empty signal generation
assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

// Write and read enable signals
assign wen = winc;
assign ren = rinc;

// Output connections
assign rdata = RAM_rdata;

endmodule