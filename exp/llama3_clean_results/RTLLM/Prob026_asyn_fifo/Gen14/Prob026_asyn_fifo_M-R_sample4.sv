// Dual-Port RAM Module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [WIDTH-1:0] wdata,
    input [$clog2(DEPTH)-1:0] waddr,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule

// Clock Domain Crossing (CDC) Module
module cdc_module #(
    parameter WIDTH = 4
)(
    input wclk,
    input rclk,
    input [WIDTH-1:0] wptr,
    output reg [WIDTH-1:0] rptr_syn
);

reg [WIDTH-1:0] rptr_buff1;
reg [WIDTH-1:0] rptr_buff2;

always @(posedge wclk) begin
    rptr_buff1 <= wptr;
end

always @(posedge rclk) begin
    rptr_buff2 <= rptr_buff1;
    rptr_syn <= rptr_buff2;
end

endmodule

// Asynchronous FIFO Module
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

reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_gray;
reg [ADDR_WIDTH-1:0] rptr_gray;

reg [ADDR_WIDTH-1:0] rptr_syn;

// Instantiate dual-port RAM module
dual_port_RAM #(.WIDTH(WIDTH),.DEPTH(DEPTH)) RAM (
   .wclk(wclk),
   .wenc(winc),
   .wdata(wdata),
   .waddr(wptr[ADDR_WIDTH-2:0]),
   .rclk(rclk),
   .renc(rinc),
   .raddr(rptr[ADDR_WIDTH-2:0]),
   .rdata(rdata)
);

// Instantiate CDC module for read pointer synchronization
cdc_module #(.WIDTH(ADDR_WIDTH)) CDC (
   .wclk(wclk),
   .rclk(rclk),
   .wptr(rptr),
   .rptr_syn(rptr_syn)
);

// Gray code conversion
assign wptr_gray = (wptr >> 1) ^ wptr;
assign rptr_gray = (rptr >> 1) ^ rptr;

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= (wptr + 1) % DEPTH;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= (rptr + 1) % DEPTH;
    end
end

// Full signal generation
assign wfull = (wptr_gray == {~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]});

// Empty signal generation
assign rempty = (rptr_gray == wptr_gray);

endmodule