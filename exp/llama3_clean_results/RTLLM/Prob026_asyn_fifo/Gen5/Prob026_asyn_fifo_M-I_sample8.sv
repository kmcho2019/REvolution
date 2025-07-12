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

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] rptr_syn;

// Write pointer increment
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc && ~wfull) begin
        wptr <= wptr + 1;
    end
end

// Read pointer increment
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        rptr <= rptr + 1;
    end
end

// Synchronize write pointer to read clock domain
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;
always @(posedge rclk) begin
    wptr_sync1 <= wptr;
    wptr_sync2 <= wptr_sync1;
    wptr_syn <= wptr_sync2;
end

// Synchronize read pointer to write clock domain
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;
always @(posedge wclk) begin
    rptr_sync1 <= rptr;
    rptr_sync2 <= rptr_sync1;
    rptr_syn <= rptr_sync2;
end

// Write operation
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        RAM_MEM[wptr[ADDR_WIDTH-2:0]] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        rdata <= RAM_MEM[rptr[ADDR_WIDTH-2:0]];
    end
end

// Full and empty signals
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;
always @(posedge wclk) begin
    wptr_gray <= wptr ^ (wptr >> 1);
end
always @(posedge rclk) begin
    rptr_gray <= rptr ^ (rptr >> 1);
end
assign wfull = (wptr_gray == (rptr_gray + 1) % (DEPTH + 1));
assign rempty = (rptr_gray == wptr_gray);

endmodule