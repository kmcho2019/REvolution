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

// Write and read pointer management
logic [$clog2(DEPTH)-1:0] waddr_bin;
logic [$clog2(DEPTH)-1:0] raddr_bin;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
logic [$clog2(DEPTH)-1:0] wptr;
logic [$clog2(DEPTH)-1:0] rptr;

always_comb begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Pointer buffers
logic [$clog2(DEPTH)-1:0] wptr_buff;
logic [$clog2(DEPTH)-1:0] rptr_syn;

always_ff @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always_ff @(posedge rclk) begin
    if (~rrstn) begin
        rptr_syn <= 0;
    end else begin
        rptr_syn <= wptr_buff;
    end
end

// Full and empty signals
always_comb begin
    wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
    rempty = (rptr == wptr);
end

// Input and output connections
logic wenc;
logic renc;
logic [$clog2(DEPTH)-1:0] waddr;
logic [$clog2(DEPTH)-1:0] raddr;

always_comb begin
    wenc = winc;
    renc = rinc;
    waddr = waddr_bin[$clog2(DEPTH)-2:0];
    raddr = raddr_bin[$clog2(DEPTH)-2:0];
end

endmodule