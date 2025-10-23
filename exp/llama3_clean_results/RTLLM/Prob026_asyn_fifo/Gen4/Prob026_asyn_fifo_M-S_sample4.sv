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

// Write operation
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        RAM_MEM[wptr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        rdata <= RAM_MEM[rptr];
    end
end

// Synchronize write pointer to read clock domain
always @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Synchronize read pointer to write clock domain
always @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Full and empty signals
assign wfull = (wptr == (rptr + 1) % DEPTH);
assign rempty = (rptr == wptr);

endmodule