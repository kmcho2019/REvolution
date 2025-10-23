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
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

// Synchronized write and read pointers
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] rptr_sync;

// Gray code conversion
assign wptr_sync = waddr_bin ^ (waddr_bin >> 1);
assign rptr_sync = raddr_bin ^ (raddr_bin >> 1);

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        ram[waddr_bin] <= wdata;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rdata <= ram[raddr_bin];
    end
end

// Full and empty signal generation
assign wfull = (wptr_sync[ADDR_WIDTH-1] != rptr_sync[ADDR_WIDTH-1] && wptr_sync[ADDR_WIDTH-2:0] == rptr_sync[ADDR_WIDTH-2:0]);
assign rempty = (rptr_sync == wptr_sync);

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