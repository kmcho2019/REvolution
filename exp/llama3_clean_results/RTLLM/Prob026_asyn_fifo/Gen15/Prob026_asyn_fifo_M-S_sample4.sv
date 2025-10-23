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
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_sync;
reg [ADDR_WIDTH-1:0] rptr_sync;

// Write Pointer Increment
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc & ~wfull) begin
        wptr <= (wptr + 1) % DEPTH;
    end
end

// Read Pointer Increment
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc & ~rempty) begin
        rptr <= (rptr + 1) % DEPTH;
    end
end

// Synchronization Logic
always @(posedge wclk) begin
    wptr_sync <= wptr;
end

always @(posedge rclk) begin
    rptr_sync <= rptr;
end

// Write Operation
always @(posedge wclk) begin
    if (winc & ~wfull) begin
        ram[wptr] <= wdata;
    end
end

// Read Operation
always @(posedge rclk) begin
    if (rinc & ~rempty) begin
        rdata <= ram[rptr];
    end
end

// Full and Empty Signal Generation
always @(*) begin
    wfull = (wptr == ((rptr + 1) % DEPTH));
    rempty = (rptr == wptr);
end

endmodule