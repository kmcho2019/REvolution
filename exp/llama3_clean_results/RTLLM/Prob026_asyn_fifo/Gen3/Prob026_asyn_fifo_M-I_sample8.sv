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

// Write pointer logic
reg [ADDR_WIDTH-1:0] waddr_bin;
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
reg [ADDR_WIDTH-1:0] raddr_bin;
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Dual-port RAM submodule
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) ram_inst (
   .wclk(wclk),
   .wenc(winc & ~wfull),
   .waddr(waddr_bin[ADDR_WIDTH-2:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc & ~rempty),
   .raddr(raddr_bin[ADDR_WIDTH-2:0]),
   .rdata(rdata)
);

// Gray code conversion for write pointer
reg [ADDR_WIDTH-1:0] wptr;
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Gray code conversion for read pointer
reg [ADDR_WIDTH-1:0] rptr;
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Synchronize write pointer to read clock domain
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] wptr_sync_reg1;
reg [ADDR_WIDTH-1:0] wptr_sync_reg2;
always @(posedge rclk) begin
    wptr_sync_reg1 <= wptr;
    wptr_sync_reg2 <= wptr_sync_reg1;
    wptr_syn <= wptr_sync_reg2;
end

// Synchronize read pointer to write clock domain
reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] rptr_sync_reg1;
reg [ADDR_WIDTH-1:0] rptr_sync_reg2;
always @(posedge wclk) begin
    rptr_sync_reg1 <= rptr;
    rptr_sync_reg2 <= rptr_sync_reg1;
    rptr_syn <= rptr_sync_reg2;
end

// Full and empty signals
assign wfull = (wptr_syn == ({~rptr[ADDR_WIDTH-1], rptr[ADDR_WIDTH-2:0]}));
assign rempty = (rptr_syn == wptr_syn);

endmodule

// Dual-port RAM submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-2:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-2:0] raddr,
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