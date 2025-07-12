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
    output reg wfull, 
    output reg rempty, 
    output reg [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;

assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_syn == wptr);

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end
    else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end
    else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

always @(posedge wclk) begin
    wptr_syn <= rptr_buff;
end

always @(posedge rclk) begin
    rptr_syn <= wptr_buff;
end

always @(posedge wclk) begin
    wptr <= (waddr_bin ^ (waddr_bin >> 1));
end

always @(posedge rclk) begin
    rptr <= (raddr_bin ^ (raddr_bin >> 1));
end

dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) u_dual_port_RAM(
    .wclk(wclk), 
    .wenc(winc), 
    .waddr(waddr_bin[$clog2(DEPTH)-2:0]), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(rinc), 
    .raddr(raddr_bin[$clog2(DEPTH)-2:0]), 
    .rdata(rdata)
);

endmodule