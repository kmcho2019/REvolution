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
reg [ADDR_WIDTH-1:0] wptr_next;

// Read pointer
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] rptr_next;

// Synchronized write pointer
reg [ADDR_WIDTH-1:0] wptr_syn1;
reg [ADDR_WIDTH-1:0] wptr_syn2;

// Synchronized read pointer
reg [ADDR_WIDTH-1:0] rptr_syn1;
reg [ADDR_WIDTH-1:0] rptr_syn2;

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

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc && ~wfull) begin
        wptr <= wptr + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc && ~rempty) begin
        rptr <= rptr + 1;
    end
end

// Two-stage synchronizer for write pointer
always @(posedge rclk) begin
    wptr_syn1 <= wptr;
    wptr_syn2 <= wptr_syn1;
end

// Two-stage synchronizer for read pointer
always @(posedge wclk) begin
    rptr_syn1 <= rptr;
    rptr_syn2 <= rptr_syn1;
end

// Gray code conversion for write pointer
assign wptr_next = wptr ^ (wptr >> 1);

// Gray code conversion for read pointer
assign rptr_next = rptr ^ (rptr >> 1);

// Full and empty signals
assign wfull = (wptr_syn2 == ({~rptr[ADDR_WIDTH-1], rptr[ADDR_WIDTH-2:0]}));
assign rempty = (rptr_syn2 == wptr_syn2);

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