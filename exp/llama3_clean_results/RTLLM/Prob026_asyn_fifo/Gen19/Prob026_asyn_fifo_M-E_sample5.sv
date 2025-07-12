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

// Dual-port RAM
reg [WIDTH-1:0] ram[DEPTH-1:0];

always @(posedge wclk) begin
    if (winc) begin
        ram[wptr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (rinc) begin
        rdata <= ram[rptr_bin];
    end
end

// Write pointer control
reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

always @(posedge wclk) begin
    wptr_gray <= (wptr_bin >> 1) ^ wptr_bin;
end

// Read pointer control
reg [ADDR_WIDTH-1:0] rptr_bin;
reg [ADDR_WIDTH-1:0] rptr_gray;

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

always @(posedge rclk) begin
    rptr_gray <= (rptr_bin >> 1) ^ rptr_bin;
end

// Synchronizer
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;

always @(posedge rclk) begin
    wptr_sync1 <= wptr_gray;
end

always @(posedge rclk) begin
    wptr_sync2 <= wptr_sync1;
end

always @(posedge wclk) begin
    rptr_sync1 <= rptr_gray;
end

always @(posedge wclk) begin
    rptr_sync2 <= rptr_sync1;
end

// Full and empty detection
assign wfull = (wptr_sync2[ADDR_WIDTH-1] != rptr_gray[ADDR_WIDTH-1]) && (wptr_sync2[ADDR_WIDTH-2:0] == rptr_gray[ADDR_WIDTH-2:0]);
assign rempty = (rptr_gray == wptr_sync2);

endmodule