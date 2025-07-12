module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  rclk,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input  wclk,
    input  wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0] wdata,
    input  rclk,
    input  renc,
    input  [$clog2(DEPTH)-1:0] raddr,
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

// Asyn_fifo module
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [WIDTH-1:0] wdata_reg;

reg [2:0] wptr;
reg [2:0] rptr;
reg [2:0] wptr_buff;
reg [2:0] rptr_syn;
reg [2:0] rptr_buff;

assign wfull = (wptr == {~rptr_syn[2], rptr_syn[1:0]});
assign rempty = (rptr == wptr);

// Write pointer increment
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= wptr + 1;
    end
end

// Read pointer increment
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= rptr + 1;
    end
end

// Write pointer buffer
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

// Read pointer synchronizer
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_syn <= 0;
    end else begin
        rptr_syn <= rptr_buff;
    end
end

// Read pointer buffer
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Gray code conversion
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr <= 0;
    end else begin
        wptr <= (waddr_bin >> 1) ^ waddr_bin;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr <= 0;
    end else begin
        rptr <= (raddr_bin >> 1) ^ raddr_bin;
    end
end

// Dual-port RAM instantiation
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin[1:0]),
    .rdata(rdata)
);

endmodule