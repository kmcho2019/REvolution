// Dual-port RAM module
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

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] waddr_bin;
reg [WIDTH-1:0] raddr_bin;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;
reg wenc;
reg renc;

// Dual-port RAM instantiation
dual_port_RAM RAM_inst(
    .wclk(wclk), 
    .wenc(wenc), 
    .waddr(waddr_bin[$clog2(DEPTH)-1:0]), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(renc), 
    .raddr(raddr_bin[$clog2(DEPTH)-1:0]), 
    .rdata(rdata)
);

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Pointer buffering
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
        rptr_buff <= rptr;
    end
end

// Full and empty detection
assign wfull = (wptr_buff[$clog2(DEPTH)-1:0] == {~rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_buff[$clog2(DEPTH)-1:0] == wptr_buff[$clog2(DEPTH)-1:0]);

// Write and read enable signals
always @(posedge wclk) begin
    if (~wrstn) begin
        wenc <= 0;
    end else if (winc) begin
        wenc <= 1;
    end else begin
        wenc <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        renc <= 0;
    end else if (rinc) begin
        renc <= 1;
    end else begin
        renc <= 0;
    end
end

endmodule