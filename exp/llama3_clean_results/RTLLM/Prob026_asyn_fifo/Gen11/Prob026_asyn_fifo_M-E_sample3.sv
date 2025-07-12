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

// Dual-Port RAM
reg [WIDTH-1:0] ram [DEPTH-1:0];

// Write Pointer Management
reg [ADDR_WIDTH-1:0] wptr;
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc && ~wfull) begin
        wptr <= wptr + 1;
    end
end

// Read Pointer Management
reg [ADDR_WIDTH-1:0] rptr;
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        rptr <= rptr + 1;
    end
end

// Write Operation
always @(posedge wclk) begin
    if (winc && ~wfull) begin
        ram[wptr] <= wdata;
    end
end

// Read Operation
always @(posedge rclk) begin
    if (rinc && ~rempty) begin
        rdata <= ram[rptr];
    end
end

// Full and Empty Signal Generation
always @(posedge wclk) begin
    if (wptr == (rptr + 1) % DEPTH) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr == wptr) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

endmodule