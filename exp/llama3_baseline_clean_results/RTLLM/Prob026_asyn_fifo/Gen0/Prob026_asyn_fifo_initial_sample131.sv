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

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [2:0] wptr;
reg [2:0] rptr;
reg [2:0] wptr_buff;
reg [2:0] rptr_buff;
reg [2:0] rptr_syn;

assign wfull = (wptr == (~rptr_syn[2]) ? 1 : 0);
assign rempty = (rptr == wptr) ? 1 : 0;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr_buff + 1;
        wptr <= wptr_buff;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr_buff + 1;
        rptr <= rptr_buff;
    end
end

always @(posedge wclk) begin
    wptr_syn <= wptr;
end

always @(posedge rclk) begin
    rptr_syn <= rptr;
end

assign wptr[2:0] = {wptr_buff[2]^wptr_buff[1], wptr_buff[2]^wptr_buff[0], wptr_buff[1]^wptr_buff[0]};
assign rptr[2:0] = {rptr_buff[2]^rptr_buff[1], rptr_buff[2]^rptr_buff[0], rptr_buff[1]^rptr_buff[0]};

always @(posedge wclk) begin
    if (winc) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata <= RAM_MEM[raddr_bin];
end

endmodule