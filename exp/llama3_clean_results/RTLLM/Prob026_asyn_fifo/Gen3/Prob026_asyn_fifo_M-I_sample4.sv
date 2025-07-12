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

// Write pointer
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] wptr_gray;

// Read pointer
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] rptr_gray;

// Synchronized write pointer
reg [ADDR_WIDTH-1:0] wptr_syn;

// Synchronized read pointer
reg [ADDR_WIDTH-1:0] rptr_syn;

// Dual-port RAM submodule
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(winc & ~wfull),
    .waddr(wptr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc & ~rempty),
    .raddr(rptr),
    .rdata(rdata)
);

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

// Gray code conversion for write pointer
assign wptr_gray = wptr ^ (wptr >> 1);

// Gray code conversion for read pointer
assign rptr_gray = rptr ^ (rptr >> 1);

// Synchronize write pointer to read clock domain
always @(posedge rclk) begin
    wptr_syn <= wptr_gray;
end

// Synchronize read pointer to write clock domain
always @(posedge wclk) begin
    rptr_syn <= rptr_gray;
end

// Full and empty signals
assign wfull = (wptr_gray == ({~rptr[ADDR_WIDTH-1], rptr[ADDR_WIDTH-2:0]}));
assign rempty = (rptr_gray == wptr_gray);

endmodule

// Dual-port RAM submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule