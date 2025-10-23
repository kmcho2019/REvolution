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
    if(wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if(renc) begin
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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] rptr_syn;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;

wire wenc;
wire renc;

assign wenc = winc & ~wfull;
assign renc = rinc & ~rempty;

always @(posedge wclk) begin
    if(~wrstn) begin
        waddr_bin <= 0;
    end else if(winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if(~rrstn) begin
        raddr_bin <= 0;
    end else if(rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2]^waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]^waddr_bin[$clog2(DEPTH)-4]};
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2]^raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]^raddr_bin[$clog2(DEPTH)-4]};
end

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

always @(posedge rclk) begin
    rptr_syn <= wptr_buff;
end

always @(posedge wclk) begin
    wfull <= (rptr_syn == {~wptr[$clog2(DEPTH)-1], wptr[$clog2(DEPTH)-2:0]});
end

always @(posedge rclk) begin
    rempty <= (rptr == wptr_buff);
end

dual_port_RAM u_ram(
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin[$clog2(DEPTH)-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin[$clog2(DEPTH)-2:0]),
    .rdata(rdata)
);

endmodule