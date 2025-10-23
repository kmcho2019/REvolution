// Dual-port RAM module
module dual_port_RAM(
    input wclk,
    input wenc,
    input [$clog2($DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2($DEPTH)-1:0] raddr,
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
module asyn_fifo(
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

parameter DEPTH = 16;
parameter WIDTH = 8;

wire [WIDTH-1:0] ram_rdata;
reg [WIDTH-1:0] ram_wdata;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

assign wfull = (wptr == ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}));
assign rempty = (rptr_syn == wptr);

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr_buff + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr_buff + 1;
    end
end

always @(posedge wclk) begin
    wptr <= {wptr_buff[$clog2(DEPTH)-1], wptr_buff[$clog2(DEPTH)-2:0] ^ wptr_buff[$clog2(DEPTH)-1:1]};
end

always @(posedge rclk) begin
    rptr_syn <= {rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2:0] ^ rptr_buff[$clog2(DEPTH)-1:1]};
end

dual_port_RAM u_ram(
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[$clog2(DEPTH)-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin[$clog2(DEPTH)-2:0]),
    .rdata(ram_rdata)
);

assign rdata = ram_rdata;

endmodule