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
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr_gray <= waddr_bin ^ (waddr_bin >> 1);
    end
end

// Read pointer update
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_gray <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr_gray <= raddr_bin ^ (raddr_bin >> 1);
    end
end

// Read pointer synchronizer
reg [ADDR_WIDTH-1:0] rptr_syn_temp;
always @(posedge wclk) begin
    rptr_syn_temp <= rptr_gray;
    rptr_syn <= rptr_syn_temp;
end

// Write pointer synchronizer
reg [ADDR_WIDTH-1:0] wptr_syn_temp;
always @(posedge rclk) begin
    wptr_syn_temp <= wptr_gray;
    wptr_syn <= wptr_syn_temp;
end

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        ram[waddr_bin] <= wdata;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= ram[raddr_bin];
    end
end

// Full signal generation
assign wfull = (wptr_gray == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});

// Empty signal generation
assign rempty = (rptr_gray == wptr_syn);

endmodule