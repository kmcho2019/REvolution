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

reg [ADDR_WIDTH-1:0] wptr_bin;
reg [ADDR_WIDTH-1:0] rptr_bin;

// Dual-port RAM module
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) ram_inst (
   .wclk(wclk),
   .wenc(winc),
   .waddr(wptr_bin[ADDR_WIDTH-2:0]), // Adjusted to match the actual address width
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc),
   .raddr(rptr_bin[ADDR_WIDTH-2:0]), // Adjusted to match the actual address width
   .rdata(rdata)
);

// Write pointer management
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

// Read pointer management
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

// Two-stage synchronization for write pointer
reg [ADDR_WIDTH-1:0] wptr_sync1;
reg [ADDR_WIDTH-1:0] wptr_sync2;
always @(posedge rclk) wptr_sync1 <= wptr_bin;
always @(posedge rclk) wptr_sync2 <= wptr_sync1;

// Two-stage synchronization for read pointer
reg [ADDR_WIDTH-1:0] rptr_sync1;
reg [ADDR_WIDTH-1:0] rptr_sync2;
always @(posedge wclk) rptr_sync1 <= rptr_bin;
always @(posedge wclk) rptr_sync2 <= rptr_sync1;

// Full and empty signal generation using direct comparison
assign wfull = (wptr_bin == (rptr_sync2 + 1) % DEPTH);
assign rempty = (rptr_bin == wptr_bin);

endmodule

// Dual-port RAM module definition
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [3:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [3:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram[DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

endmodule