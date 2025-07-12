module dual_port_RAM(
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

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] wptr_syn;
reg [WIDTH-1:0] rptr_syn;
reg wfull;
reg rempty;

dual_port_RAM RAM(
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata)
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
    wptr <= {waddr_bin[$clog2(DEPTH)-1]^waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-2:$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]};
end

always @(posedge rclk) begin
    rptr_syn <= {raddr_bin[$clog2(DEPTH)-1]^raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-2:$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]};
end

reg [1:0] wptr_delay;
always @(posedge rclk) begin
    if (~rrstn) begin
        wptr_delay <= 0;
    end else begin
        wptr_delay <= {wptr_delay[0], wptr_syn[$clog2(DEPTH)-1]};
    end
end

reg [1:0] rptr_delay;
always @(posedge wclk) begin
    if (~wrstn) begin
        rptr_delay <= 0;
    end else begin
        rptr_delay <= {rptr_delay[0], rptr_syn[$clog2(DEPTH)-1]};
    end
end

always @(*) begin
    if (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:$clog2(DEPTH)-3]}) begin
        wfull = 1'b1;
    end else begin
        wfull = 1'b0;
    end
end

always @(*) begin
    if (rptr_syn == wptr_syn) begin
        rempty = 1'b1;
    end else begin
        rempty = 1'b0;
    end
end

endmodule