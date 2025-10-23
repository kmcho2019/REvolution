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

// Ring buffer
reg [WIDTH-1:0] ring_buffer [DEPTH-1:0];

// Token-based pointer management system
reg [ADDR_WIDTH-1:0] wtoken;
reg [ADDR_WIDTH-1:0] rtoken;

// FIFOs for token circulation
reg [ADDR_WIDTH-1:0] wtoken_fifo [1:0];
reg [ADDR_WIDTH-1:0] rtoken_fifo [1:0];

// Write clock logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wtoken <= 0;
        wtoken_fifo[0] <= 0;
        wtoken_fifo[1] <= 0;
    end else if (winc && ~wfull) begin
        ring_buffer[wtoken] <= wdata;
        wtoken <= (wtoken + 1) % DEPTH;
        wtoken_fifo[0] <= wtoken;
    end
end

// Read clock logic
always @(posedge rclk) begin
    if (~rrstn) begin
        rtoken <= 0;
        rtoken_fifo[0] <= 0;
        rtoken_fifo[1] <= 0;
    end else if (rinc && ~rempty) begin
        rdata <= ring_buffer[rtoken];
        rtoken <= (rtoken + 1) % DEPTH;
        rtoken_fifo[0] <= rtoken;
    end
end

// Token circulation logic
always @(posedge wclk) begin
    wtoken_fifo[1] <= wtoken_fifo[0];
end

always @(posedge rclk) begin
    rtoken_fifo[1] <= rtoken_fifo[0];
    rtoken <= wtoken_fifo[1];
end

// Full and empty signal generation
assign wfull = (wtoken == (rtoken + 1) % DEPTH);
assign rempty = (rtoken == wtoken);

endmodule