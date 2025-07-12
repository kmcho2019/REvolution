module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
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

wire [$clog2(DEPTH)-1:0] wptr;
wire [$clog2(DEPTH)-1:0] rptr;
wire [$clog2(DEPTH)-1:0] wptr_syn;
wire [$clog2(DEPTH)-1:0] rptr_syn;

reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

wire wen;
wire ren;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

assign wptr = waddr_bin ^ (waddr_bin >> 1);
assign rptr = raddr_bin ^ (raddr_bin >> 1);

reg [$clog2(DEPTH)-1:0] wptr_sync1;
reg [$clog2(DEPTH)-1:0] wptr_sync2;

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_sync1 <= 0;
    end else begin
        wptr_sync1 <= wptr;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_sync2 <= 0;
    end else begin
        wptr_sync2 <= wptr_sync1;
    end
end

assign wptr_syn = wptr_sync2;

reg [$clog2(DEPTH)-1:0] rptr_sync1;
reg [$clog2(DEPTH)-1:0] rptr_sync2;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_sync1 <= 0;
    end else begin
        rptr_sync1 <= rptr;
    end
end

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_sync2 <= 0;
    end else begin
        rptr_sync2 <= rptr_sync1;
    end
end

assign rptr_syn = rptr_sync2;

assign wfull = (wptr_syn[$clog2(DEPTH)-1] != rptr_syn[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);
assign rempty = (wptr_syn == rptr_syn);

assign wen = winc;
assign ren = rinc;

always @(posedge wclk) begin
    if (wen) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata <= RAM_MEM[raddr_bin];
end

endmodule