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
reg [WIDTH-1:0] ram [DEPTH-1:0];

// Write and read pointers
reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] rptr_bin;
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;

// Clock domain crossing (CDC) signals
reg wptr_sync;
reg rptr_sync;

// Full and empty signal generation
reg [ADDR_WIDTH-1:0] wptr_count;
reg [ADDR_WIDTH-1:0] rptr_count;

// Initialize variables
initial begin
    wptr_bin = 0;
    rptr_bin = 0;
    wptr_gray = 0;
    rptr_gray = 0;
    wptr_sync = 0;
    rptr_sync = 0;
    wptr_count = 0;
    rptr_count = 0;
    wfull = 0;
    rempty = 1;
    rdata = 0;
end

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
        wptr_gray <= 0;
        wptr_count <= 0;
    end else if (winc && ~wfull) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
        wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
        wptr_count <= wptr_count + 1;
        ram[wptr_bin] <= wdata;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
        rptr_gray <= 0;
        rptr_count <= 0;
    end else if (rinc && ~rempty) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
        rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
        rptr_count <= rptr_count + 1;
        rdata <= ram[rptr_bin];
    end
end

// Clock domain crossing (CDC)
always @(posedge wclk) begin
    wptr_sync <= wptr_gray;
end

always @(posedge rclk) begin
    rptr_sync <= rptr_gray;
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (wptr_count == DEPTH) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr_count == 0) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Dynamic clock gating
reg wclk_enable;
reg rclk_enable;
always @(posedge wclk) begin
    if (~wrstn) begin
        wclk_enable <= 0;
    end else if (winc && ~wfull) begin
        wclk_enable <= 1;
    end else begin
        wclk_enable <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rclk_enable <= 0;
    end else if (rinc && ~rempty) begin
        rclk_enable <= 1;
    end else begin
        rclk_enable <= 0;
    end
end

endmodule