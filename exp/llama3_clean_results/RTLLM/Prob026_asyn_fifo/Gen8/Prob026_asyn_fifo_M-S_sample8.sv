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
reg [WIDTH-1:0] dpram [DEPTH-1:0];

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= waddr_bin;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= raddr_bin;
    end
end

reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] rptr_sync;
always @(posedge rclk) begin
    wptr_sync <= wptr;
end

always @(posedge wclk) begin
    rptr_sync <= rptr;
end

always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if (wptr_sync == (rptr_sync + 1) % DEPTH) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else if (rptr == wptr_sync) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        dpram[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= dpram[raddr_bin];
    end
end

endmodule