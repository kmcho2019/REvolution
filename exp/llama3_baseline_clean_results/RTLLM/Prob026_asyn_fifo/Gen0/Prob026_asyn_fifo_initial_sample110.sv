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

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [WIDTH-1:0] wdata_reg;
reg wenc;
reg renc;
reg wfull_reg;
reg rempty_reg;

wire [$clog2(DEPTH)-1:0] wptr;
wire [$clog2(DEPTH)-1:0] rptr;
wire [$clog2(DEPTH)-1:0] rptr_syn;
wire [$clog2(DEPTH)-1:0] wptr_syn;

assign wfull = wfull_reg;
assign rempty = rempty_reg;

always @(posedge wclk) begin
    if(~wrstn) begin
        waddr_bin <= 0;
    end
    else if(winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if(~rrstn) begin
        raddr_bin <= 0;
    end
    else if(rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

assign wptr = waddr_bin ^ (waddr_bin >> 1);
assign rptr = raddr_bin ^ (raddr_bin >> 1);

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
    wptr_syn <= rptr_buff;
end

always @(posedge wclk) begin
    if(winc) begin
        wenc <= 1;
    end
    else begin
        wenc <= 0;
    end
end

always @(posedge rclk) begin
    if(rinc) begin
        renc <= 1;
    end
    else begin
        renc <= 0;
    end
end

always @(posedge wclk) begin
    if(winc) begin
        wdata_reg <= wdata;
    end
end

dual_port_RAM RAM(
   .wclk(wclk), 
   .wenc(wenc), 
   .waddr(waddr_bin[$clog2(DEPTH)-1:1]), 
   .wdata(wdata_reg), 
   .rclk(rclk), 
   .renc(renc), 
   .raddr(raddr_bin[$clog2(DEPTH)-1:1]), 
   .rdata(rdata)
);

always @(posedge wclk) begin
    if(wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull_reg <= 1;
    end
    else begin
        wfull_reg <= 0;
    end
end

always @(posedge rclk) begin
    if(rptr == wptr_syn) begin
        rempty_reg <= 1;
    end
    else begin
        rempty_reg <= 0;
    end
end

endmodule