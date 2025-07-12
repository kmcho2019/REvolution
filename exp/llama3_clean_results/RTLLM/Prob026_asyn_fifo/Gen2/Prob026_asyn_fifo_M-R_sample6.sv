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

// Explicitly declare wires and regs
reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;

// Write pointer increment
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer increment
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc && ~rempty) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
assign wptr = waddr_bin ^ (waddr_bin >> 1);
assign rptr = raddr_bin ^ (raddr_bin >> 1);

// Pointer synchronizers
always @(posedge wclk) begin
    wptr_syn <= wptr;
    wptr_buff <= wptr_syn;
end

always @(posedge rclk) begin
    rptr_syn <= rptr;
    rptr_buff <= rptr_syn;
end

// Full and empty signals
assign wfull = (wptr_buff == ({~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]}));
assign rempty = (rptr_syn == wptr_buff);

// Enable signals for write and read operations
assign wen = (winc && ~wfull && wrstn);
assign ren = (rinc && ~rempty && rrstn);

// Dual-port RAM submodule
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) ram_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin),
   .rdata(rdata)
);

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