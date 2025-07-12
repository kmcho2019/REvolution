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
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;
reg [ADDR_WIDTH-1:0] rptr_syn;

// Write pointer update
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_gray <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr_gray <= waddr_bin ^ (waddr_bin >> 1);
    end
end

// Read pointer update
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_gray <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr_gray <= raddr_bin ^ (raddr_bin >> 1);
    end
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_gray;
end

// Dual-Port RAM
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        ram[waddr_bin] <= wdata;
    end
end

assign rdata = ram[raddr_bin];

// Full and empty signal generation
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if (winc && (wptr_gray[ADDR_WIDTH-1] != rptr_syn[ADDR_WIDTH-1]) && (wptr_gray[ADDR_WIDTH-2:0] == rptr_syn[ADDR_WIDTH-2:0])) begin
        wfull <= 1;
    end else if (~wfull && winc) begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
        rdata <= 0;
    end else if (rinc && (rptr_gray == wptr_gray)) begin
        rempty <= 1;
        rdata <= 0;
    end else if (rinc && ~rempty) begin
        rempty <= 0;
    end
end

endmodule