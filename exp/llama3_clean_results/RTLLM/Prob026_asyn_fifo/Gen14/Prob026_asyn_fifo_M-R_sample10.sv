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

// Dual-Port RAM
reg [WIDTH-1:0] ram [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;
reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_syn;

// Initialize variables
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr_gray = 0;
    rptr_gray = 0;
    rptr_syn = 0;
    wptr_syn = 0;
    wfull = 0;
    rempty = 1;
    rdata = 0;
end

// Write pointer update
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_gray <= 0;
    end else begin
        if (winc && ~wfull) begin
            waddr_bin <= (waddr_bin + 1) % DEPTH;
            wptr_gray <= waddr_bin ^ (waddr_bin >> 1);
            ram[waddr_bin] <= wdata;
        end
    end
end

// Read pointer update and data read
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_gray <= 0;
    end else begin
        if (rinc && ~rempty) begin
            raddr_bin <= (raddr_bin + 1) % DEPTH;
            rptr_gray <= raddr_bin ^ (raddr_bin >> 1);
            rdata <= ram[raddr_bin];
        end
    end
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_gray;
end

// Write pointer synchronizer
always @(posedge rclk) begin
    wptr_syn <= wptr_gray;
end

// Full and empty signal generation
assign wfull = (wptr_gray[ADDR_WIDTH-1] != rptr_syn[ADDR_WIDTH-1]) && (wptr_gray[ADDR_WIDTH-2:0] == rptr_syn[ADDR_WIDTH-2:0]);
assign rempty = (rptr_gray == wptr_syn);

endmodule