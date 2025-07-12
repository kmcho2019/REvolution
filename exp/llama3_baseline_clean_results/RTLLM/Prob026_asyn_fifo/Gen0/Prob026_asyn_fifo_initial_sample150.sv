module dual_port_RAM (
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

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input wclk,
    input rstn,
    input wrstn,
    input winc,
    input wdata,
    input rclk,
    input rrstn,
    input rinc,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] rdata_out;

reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr, rptr_syn;

reg wenc, renc;

dual_port_RAM ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin),
    .rdata(rdata_out)
);

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1:1] ^ waddr_bin[$clog2(DEPTH)-2:0], waddr_bin[0]};
end

always @(posedge rclk) begin
    rptr_syn <= {raddr_bin[$clog2(DEPTH)-1:1] ^ raddr_bin[$clog2(DEPTH)-2:0], raddr_bin[0]};
end

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr_syn;
    end
end

assign wfull = (wptr == {~rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_syn == wptr);

assign wenc = winc;
assign renc = rinc;

assign rdata = rdata_out;

endmodule