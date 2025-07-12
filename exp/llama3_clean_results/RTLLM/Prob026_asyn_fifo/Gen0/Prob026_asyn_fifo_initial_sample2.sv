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

wire renc;
reg renc_reg;

assign wenc = winc & ~wfull;
assign renc = rinc & ~rempty;

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
    end else if (renc) begin
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
        rptr_syn_reg <= rptr_syn;
    end
end

assign rptr_syn = rptr ^ (rptr >> 1);

// Write pointer synchronizer
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_syn_reg <= 0;
    end else begin
        wptr_syn_reg <= wptr_syn;
    end
end

assign wptr_syn = wptr ^ (wptr >> 1);

// Full and empty signal generation
assign wfull = (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_syn == wptr_syn);

// RAM instantiation
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) RAM_INST (
   .wclk(wclk),
   .renc(wenc),
   .waddr(waddr_bin_reg),
   .wdata(wdata),
   .rclk(rclk),
   .renc(renc),
   .raddr(raddr_bin_reg),
   .rdata(rdata)
);

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input renc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-1:0] raddr,
    output [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
    if (renc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata <= RAM_MEM[raddr];
end

endmodule