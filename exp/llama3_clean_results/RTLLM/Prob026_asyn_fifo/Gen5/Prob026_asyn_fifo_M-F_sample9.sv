module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write and read pointers
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

// Gray code conversion
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Two-stage synchronizers
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;

// Full and empty signals
reg wfull_reg;
reg rempty_reg;

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wfull_reg <= 0;
    end else if (winc && ~wfull_reg) begin
        RAM_MEM[waddr_bin] <= wdata;
        waddr_bin <= waddr_bin + 1;
        wptr <= waddr_bin;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rempty_reg <= 1;
    end else if (rinc && ~rempty_reg) begin
        rdata <= RAM_MEM[raddr_bin];
        raddr_bin <= raddr_bin + 1;
        rptr <= raddr_bin;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Two-stage synchronizers
always @(posedge rclk) begin
    wptr_sync1 <= wptr;
    wptr_sync2 <= wptr_sync1;
end

always @(posedge wclk) begin
    rptr_sync1 <= rptr;
    rptr_sync2 <= rptr_sync1;
end

// Full condition
always @(*) begin
    if (wptr_sync2 == (rptr_sync2 + 1)) begin
        wfull_reg <= 1;
    end else begin
        wfull_reg <= 0;
    end
end

// Empty condition
always @(*) begin
    if (rptr_sync2 == wptr_sync2) begin
        rempty_reg <= 1;
    end else begin
        rempty_reg <= 0;
    end
end

// Output assignments
assign wfull = wfull_reg;
assign rempty = rempty_reg;

endmodule