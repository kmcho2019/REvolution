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

// Asynchronous write and read controllers
always @(posedge wclk) begin
    if (~wrstn) begin
        // Reset
    end else if (winc && ~wfull) begin
        ram[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        // Reset
    end else if (rinc && ~rempty) begin
        rdata <= ram[raddr_bin];
    end
end

// Full and empty signal generation
always @(posedge wclk) begin
    if (~wrstn) begin
        wfull <= 0;
    end else if (wptr[ADDR_WIDTH-1]!= rptr[ADDR_WIDTH-1] && wptr[ADDR_WIDTH-2:0] == rptr[ADDR_WIDTH-2:0]) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty <= 1;
    end else if (rptr == wptr) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Clock Domain Crossing (CDC) module
reg [ADDR_WIDTH-1:0] wptr_cdc;
reg [ADDR_WIDTH-1:0] rptr_cdc;
always @(posedge wclk) begin
    wptr_cdc <= wptr;
end

always @(posedge rclk) begin
    rptr_cdc <= rptr;
end

// Metastability filter
reg [ADDR_WIDTH-1:0] wptr_meta;
reg [ADDR_WIDTH-1:0] rptr_meta;
always @(posedge wclk) begin
    wptr_meta <= wptr;
end

always @(posedge rclk) begin
    rptr_meta <= rptr;
end

endmodule