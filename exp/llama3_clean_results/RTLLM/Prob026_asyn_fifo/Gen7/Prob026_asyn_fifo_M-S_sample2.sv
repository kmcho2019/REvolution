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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] wptr_bin, rptr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray, rptr_gray;
reg [ADDR_WIDTH:0] cnt;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
        cnt <= 0;
    end else if (winc && ~wfull) begin
        wptr_bin <= wptr_bin + 1;
        wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
        ram[wptr_bin] <= wdata;
        cnt <= cnt + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
        cnt <= 0;
    end else if (rinc && ~rempty) begin
        rptr_bin <= rptr_bin + 1;
        rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
        rdata <= ram[rptr_bin];
        cnt <= cnt - 1;
    end
end

assign wfull = (cnt == DEPTH);
assign rempty = (cnt == 0);

endmodule