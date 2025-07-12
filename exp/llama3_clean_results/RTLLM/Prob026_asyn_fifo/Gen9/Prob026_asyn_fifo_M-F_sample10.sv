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
reg [WIDTH-1:0] dpram [DEPTH-1:0];

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] rptr_sync;

// Initialize variables
initial begin
    waddr_bin = 0;
    raddr_bin = 0;
    wptr = 0;
    rptr = 0;
    wptr_sync = 0;
    rptr_sync = 0;
    wfull = 0;
    rempty = 1;
    rdata = 0;
end

// Gray code conversion and pointer update
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= (waddr_bin + 1) % DEPTH;
        wptr <= waddr_bin ^ (waddr_bin >> 1);
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= (raddr_bin + 1) % DEPTH;
        rptr <= raddr_bin ^ (raddr_bin >> 1);
    end
end

// Two-stage synchronizers
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync1;
always @(posedge rclk) begin
    wptr_sync1 <= wptr;
    wptr_sync <= wptr_sync1;
end

always @(posedge wclk) begin
    rptr_sync1 <= rptr;
    rptr_sync <= rptr_sync1;
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if (wptr_sync[ADDR_WIDTH-1] != rptr[ADDR_WIDTH-1] && wptr_sync[ADDR_WIDTH-2:0] == rptr[ADDR_WIDTH-2:0]) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else if (rptr == wptr_sync) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Write operation
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        dpram[waddr_bin] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= dpram[raddr_bin];
    end
end

endmodule