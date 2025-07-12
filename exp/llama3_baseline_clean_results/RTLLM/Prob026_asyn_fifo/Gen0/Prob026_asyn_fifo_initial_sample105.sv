module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  wclk,
    input  rstn,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output [WIDTH-1:0] rdata,
    output wfull,
    output rempty
);

reg [WIDTH-1:0] ram [0:DEPTH-1];

reg [WIDTH-1:0] rdata_out;
reg wfull_out, rempty_out;

reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_bin, rptr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_bin <= waddr_bin;
        wptr_buff <= wptr_bin;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_bin <= raddr_bin;
        rptr_buff <= rptr_bin;
    end
end

always @(posedge wclk) begin
    if (winc) begin
        ram[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata_out <= ram[raddr_bin];
end

assign wptr = (wptr_bin[$clog2(DEPTH)-1:1] ^ wptr_bin[$clog2(DEPTH)-2:0]) << 1;
assign rptr = (rptr_bin[$clog2(DEPTH)-1:1] ^ rptr_bin[$clog2(DEPTH)-2:0]) << 1;

always @(posedge wclk) begin
    wptr_syn <= wptr;
end

always @(posedge rclk) begin
    rptr_syn <= rptr;
end

always @(*) begin
    wfull_out = (wptr_syn == ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}));
    rempty_out = (rptr_syn == wptr_syn);
end

assign wfull = wfull_out;
assign rempty = rempty_out;
assign rdata = rdata_out;

endmodule