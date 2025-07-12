module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [WIDTH-1:0] rdata_reg;
reg wfull_reg;
reg rempty_reg;

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr_buff + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr_buff + 1;
    end
end

always @(posedge wclk) begin
    wptr <= {wptr_buff[$clog2(DEPTH)-1], wptr_buff[$clog2(DEPTH)-2] ^ wptr_buff[$clog2(DEPTH)-1], wptr_buff[$clog2(DEPTH)-3] ^ wptr_buff[$clog2(DEPTH)-2], wptr_buff[$clog2(DEPTH)-4] ^ wptr_buff[$clog2(DEPTH)-3]};
    wptr_syn <= wptr;
end

always @(posedge rclk) begin
    rptr <= {rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-2] ^ rptr_buff[$clog2(DEPTH)-1], rptr_buff[$clog2(DEPTH)-3] ^ rptr_buff[$clog2(DEPTH)-2], rptr_buff[$clog2(DEPTH)-4] ^ rptr_buff[$clog2(DEPTH)-3]};
    rptr_syn <= rptr;
end

always @(posedge wclk) begin
    if (winc && ~wfull_reg) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (rinc && ~rempty_reg) begin
        rdata_reg <= RAM_MEM[raddr_bin];
    end
end

always @(*) begin
    wfull_reg = (wptr == (~rptr_syn[$clog2(DEPTH)-1] ^ rptr_syn[$clog2(DEPTH)-1]) & rptr_syn[$clog2(DEPTH)-2:0]);
    rempty_reg = (wptr == rptr);
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;
assign rdata = rdata_reg;

endmodule