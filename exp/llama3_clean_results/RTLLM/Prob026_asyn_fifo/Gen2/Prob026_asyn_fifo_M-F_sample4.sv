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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

wire [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_reg;

wire [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin_reg;

wire [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] wptr_reg;

wire [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_reg;

wire [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_syn_reg;

wire [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn_reg;

wire wenc;
reg wenc_reg;

wire ren;
reg ren_reg;

assign wenc = winc & ~wfull;
assign ren = rinc & ~rempty;

// Write controller
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin_reg <= 0;
        wptr_reg <= 0;
    end else if (wenc) begin
        waddr_bin_reg <= waddr_bin_reg + 1;
        wptr_reg <= waddr_bin_reg;
    end
end

// Read controller
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin_reg <= 0;
        rptr_reg <= 0;
    end else if (ren) begin
        raddr_bin_reg <= raddr_bin_reg + 1;
        rptr_reg <= raddr_bin_reg;
    end
end

// Gray code conversion
assign wptr = wptr_reg ^ (wptr_reg >> 1);
assign rptr = rptr_reg ^ (rptr_reg >> 1);

// Read pointer synchronizer
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_syn_reg <= 0;
    end else begin
        rptr_syn_reg <= rptr;
    end
end

// Write pointer synchronizer
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_syn_reg <= 0;
    end else begin
        wptr_syn_reg <= wptr;
    end
end

// Full and empty signal generation
assign wfull = (wptr_syn_reg == {~rptr_syn_reg[$clog2(DEPTH)-1], rptr_syn_reg[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_syn_reg == wptr_syn_reg);

// RAM instantiation
dual_port_RAM RAM_INST (
 .wclk(wclk),
 .wenc(wenc),
 .waddr(waddr_bin_reg),
 .wdata(wdata),
 .rclk(rclk),
 .renc(ren),
 .raddr(raddr_bin_reg),
 .rdata(rdata)
);

endmodule

// Separate module declaration for dual_port_RAM
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input ren,
    input [$clog2(DEPTH)-1:0] raddr,
    output [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata <= RAM_MEM[raddr];
end

endmodule