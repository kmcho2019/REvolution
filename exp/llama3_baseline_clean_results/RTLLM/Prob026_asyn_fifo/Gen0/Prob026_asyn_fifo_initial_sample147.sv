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
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_buf, raddr_bin_buf;
reg [WIDTH-1:0] rdata_buf;
reg [$clog2(DEPTH)-1:0] wptr, rptr, wptr_syn, rptr_syn;
reg wfull_reg, rempty_reg;

assign wfull = wfull_reg;
assign rempty = rempty_reg;

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

always @(posedge wclk) begin
    wptr <= (waddr_bin[$clog2(DEPTH)-1:1] ^ (waddr_bin[$clog2(DEPTH)-2:0] >> 1)) + (waddr_bin[0] ? 1 : 0);
end

always @(posedge rclk) begin
    rptr <= (raddr_bin[$clog2(DEPTH)-1:1] ^ (raddr_bin[$clog2(DEPTH)-2:0] >> 1)) + (raddr_bin[0] ? 1 : 0);
end

always @(posedge wclk) begin
    wptr_syn <= rptr_syn;
end

always @(posedge rclk) begin
    rptr_syn <= wptr;
end

always @(posedge wclk) begin
    if (winc) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata_buf <= RAM_MEM[raddr_bin];
end

assign rdata = rdata_buf;

always @(posedge wclk) begin
    if (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull_reg <= 1'b1;
    end else begin
        wfull_reg <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr_syn) begin
        rempty_reg <= 1'b1;
    end else begin
        rempty_reg <= 1'b0;
    end
end

endmodule