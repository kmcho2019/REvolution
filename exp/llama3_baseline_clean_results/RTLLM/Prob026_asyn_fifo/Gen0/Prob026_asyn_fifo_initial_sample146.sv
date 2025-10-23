module asyn_fifo (
    wclk, 
    rclk, 
    wrstn, 
    rrstn, 
    winc, 
    rinc, 
    wdata, 
    wfull, 
    rempty, 
    rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

input wclk;
input rclk;
input wrstn;
input rrstn;
input winc;
input rinc;
input [WIDTH-1:0] wdata;
output wfull;
output rempty;
output [WIDTH-1:0] rdata;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Dual-port RAM module
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        rdata_reg <= 0;
    end
    else if (wen) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rdata_reg <= 0;
    end
    else if (ren) begin
        rdata_reg <= RAM_MEM[raddr];
    end
end

assign rdata = rdata_reg;

// Write controller
reg [3:0] waddr_bin;
reg wfull_int;
reg [WIDTH-1:0] wdata_reg;
reg wen;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end
    else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

assign wfull_int = (waddr_bin == (raddr_bin + 1)) ? 1 : 0;

assign wfull = wfull_int;

always @(posedge wclk) begin
    if (wen) begin
        wdata_reg <= wdata;
    end
end

assign wen = winc & ~wfull_int;

// Read controller
reg [3:0] raddr_bin;
reg rempty_int;
reg ren;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end
    else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

assign rempty_int = (raddr_bin == waddr_bin) ? 1 : 0;

assign rempty = rempty_int;

assign ren = rinc & ~rempty_int;

// Gray code conversion
reg [3:0] wptr;
reg [3:0] rptr;
reg [3:0] rptr_syn;

always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr_syn <= rptr;
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Pointer buffers
reg [3:0] wptr_buff;
reg [3:0] rptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end
    else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end
    else begin
        rptr_buff <= rptr;
    end
end

assign waddr = wptr[2:0];
assign raddr = rptr_syn[2:0];

endmodule