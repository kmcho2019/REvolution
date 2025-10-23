module dual_port_RAM(
    input wclk, 
    input wenc, 
    input [$clog2(16)-1:0] waddr, 
    input [7:0] wdata, 
    input rclk, 
    input renc, 
    input [$clog2(16)-1:0] raddr, 
    output reg [7:0] rdata
);

reg [7:0] RAM_MEM [0:15];

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
    input [7:0] wdata, 
    output wfull, 
    output rempty, 
    output reg [7:0] rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [3:0] waddr_bin;
reg [3:0] raddr_bin;
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;
reg wenc;
reg renc;
reg [7:0] RAM_rdata;

dual_port_RAM RAM(
    .wclk(wclk), 
    .wenc(wenc), 
    .waddr(waddr_bin), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(renc), 
    .raddr(raddr_bin), 
    .rdata(RAM_rdata)
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
    wptr <= waddr_bin ^ (waddr_bin >> 1);
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
    rptr_buff <= rptr;
end

always @(posedge wclk) begin
    if (winc) begin
        wenc <= 1;
    end else begin
        wenc <= 0;
    end
end

always @(posedge rclk) begin
    if (rinc) begin
        renc <= 1;
    end else begin
        renc <= 0;
    end
end

assign wfull = (wptr_buff[3] != rptr[3]) && (wptr_buff[2:0] == rptr[2:0]);
assign rempty = (wptr_buff == rptr);
assign rdata = RAM_rdata;

endmodule