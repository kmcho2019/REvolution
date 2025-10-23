module asyn_fifo(
    input           wclk,
    input           rstn,
    input           wrstn,
    input           rrstn,
    input           winc,
    input           rinc,
    input   [7:0]   wdata,
    output          wfull,
    output          rempty,
    output  [7:0]   rdata
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

wire wclk_buf;
reg [3:0] wptr_bin, wptr_bin_d1, wptr_bin_d2;
reg [3:0] rptr_bin, rptr_bin_d1, rptr_bin_d2;

reg [2:0] waddr, raddr;
reg wen, ren;

assign waddr = wptr_bin[2:0];
assign raddr = rptr_bin[2:0];

reg wfull_int, rempty_int;

always @(posedge wclk)
begin
    if (~wrstn)
    begin
        wptr_bin <= 4'b0;
    end
    else if (winc)
    begin
        wptr_bin <= wptr_bin + 1;
    end
end

always @(posedge rclk)
begin
    if (~rrstn)
    begin
        rptr_bin <= 4'b0;
    end
    else if (rinc)
    begin
        rptr_bin <= rptr_bin + 1;
    end
end

always @(posedge wclk)
begin
    wptr_bin_d1 <= wptr_bin;
end

always @(posedge wclk)
begin
    wptr_bin_d2 <= wptr_bin_d1;
end

always @(posedge rclk)
begin
    rptr_bin_d1 <= rptr_bin;
end

always @(posedge rclk)
begin
    rptr_bin_d2 <= rptr_bin_d1;
end

always @(posedge wclk)
begin
    if (winc)
    begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk)
begin
    rdata <= RAM_MEM[raddr];
end

assign wfull = wfull_int;
assign rempty = rempty_int;

always @(posedge wclk)
begin
    if (wptr_bin == (rptr_bin + 1))
    begin
        wfull_int <= 1'b1;
    end
    else
    begin
        wfull_int <= 1'b0;
    end
end

always @(posedge rclk)
begin
    if (rptr_bin == wptr_bin)
    begin
        rempty_int <= 1'b1;
    end
    else
    begin
        rempty_int <= 1'b0;
    end
end

endmodule