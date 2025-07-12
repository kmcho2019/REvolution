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
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;

// Initialize variables
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr = 0;
    rptr = 0;
    wfull = 0;
    rempty = 1;
    rdata = 0;
end

// Write pointer update
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end
end

// Read pointer update
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end
end

// Asynchronous write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        ram[waddr_bin] <= wdata;
    end
end

// Asynchronous read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= ram[raddr_bin];
    end
end

// Full signal generation
assign wfull = (wptr[ADDR_WIDTH-1] != rptr[ADDR_WIDTH-1]) && (wptr[ADDR_WIDTH-2:0] == rptr[ADDR_WIDTH-2:0]);

// Empty signal generation
assign rempty = (rptr == wptr);

endmodule