module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input             wclk,
    input             wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0] wdata,
    input             rclk,
    input             renc,
    input  [$clog2(DEPTH)-1:0] raddr,
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
)(
    input             wclk,
    input             wrstn,
    input             winc,
    input  [WIDTH-1:0] wdata,
    input             rclk,
    input             rrstn,
    input             rinc,
    output            wfull,
    output            rempty,
    output [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_rdata;
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;
reg [WIDTH-1:0] rptr_syn;

dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) u_ram (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(RAM_rdata)
);

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr;
    end
end

always @(*) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], ~(waddr_bin[$clog2(DEPTH)-2]), waddr_bin[$clog2(DEPTH)-3:0]};
    rptr <= {raddr_bin[$clog2(DEPTH)-1], ~(raddr_bin[$clog2(DEPTH)-2]), raddr_bin[$clog2(DEPTH)-3:0]};
end

always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:$clog2(DEPTH)-3]});
assign rempty = (wptr == rptr);
assign rdata = RAM_rdata;

endmodule