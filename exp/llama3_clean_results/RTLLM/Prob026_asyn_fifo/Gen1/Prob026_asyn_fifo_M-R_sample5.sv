module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic            wclk,
    input  logic            rclk,
    input  logic            wrstn,
    input  logic            rrstn,
    input  logic            winc,
    input  logic            rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic            wfull,
    output logic            rempty,
    output logic [WIDTH-1:0] rdata
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  logic            wclk,
    input  logic            wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic            rclk,
    input  logic            renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always_ff @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always_ff @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule

// Write pointer management
module write_ptr #(
    parameter DEPTH = 16
)(
    input  logic            wclk,
    input  logic            wrstn,
    input  logic            winc,
    output logic [$clog2(DEPTH)-1:0] wptr
);

logic [$clog2(DEPTH)-1:0] waddr_bin;
logic [$clog2(DEPTH)-1:0] wptr_bin;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

assign wptr_bin = waddr_bin ^ (waddr_bin >> 1);
assign wptr = wptr_bin;

endmodule

// Read pointer management
module read_ptr #(
    parameter DEPTH = 16
)(
    input  logic            rclk,
    input  logic            rrstn,
    input  logic            rinc,
    output logic [$clog2(DEPTH)-1:0] rptr
);

logic [$clog2(DEPTH)-1:0] raddr_bin;
logic [$clog2(DEPTH)-1:0] rptr_bin;

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

assign rptr_bin = raddr_bin ^ (raddr_bin >> 1);
assign rptr = rptr_bin;

endmodule

// Instantiate dual-port RAM module
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata)
);

// Instantiate write and read pointer management modules
write_ptr #(
    .DEPTH(DEPTH)
) write_ptr_inst (
    .wclk(wclk),
    .wrstn(wrstn),
    .winc(winc),
    .wptr(wptr)
);

read_ptr #(
    .DEPTH(DEPTH)
) read_ptr_inst (
    .rclk(rclk),
    .rrstn(rrstn),
    .rinc(rinc),
    .rptr(rptr)
);

// Synchronize write pointer with read clock
logic [$clog2(DEPTH)-1:0] wptr_syn;

always_ff @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Full and empty signals
assign wfull = (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

// Input and output connections
logic wenc;
logic renc;
logic [$clog2(DEPTH)-1:0] waddr;
logic [$clog2(DEPTH)-1:0] raddr;

assign wenc = winc;
assign renc = rinc;
assign waddr = wptr[$clog2(DEPTH)-2:0];
assign raddr = rptr[$clog2(DEPTH)-2:0];

endmodule