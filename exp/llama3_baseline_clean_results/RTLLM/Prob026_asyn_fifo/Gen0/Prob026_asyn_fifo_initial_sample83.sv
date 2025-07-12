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

// Dual-port RAM submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
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
    end else begin
        rdata <= 'z;
    end
end

endmodule

// Data write controller
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_bin;
reg [WIDTH-1:0] wdata_reg;
reg wfull_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= '0;
        wptr_bin <= '0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_bin <= wptr_bin + 1;
    end
end

// Data read controller
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] rptr_bin;
reg [WIDTH-1:0] rdata_reg;
reg rempty_reg;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= '0;
        rptr_bin <= '0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_bin <= rptr_bin + 1;
    end
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_buff;

always @(posedge wclk) begin
    rptr_buff <= rptr_bin;
    rptr_syn <= rptr_buff;
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_buff;

always @(posedge rclk) begin
    wptr_buff <= wptr_bin;
    wptr_syn <= wptr_buff;
end

// Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr_gray;
reg [$clog2(DEPTH)-1:0] rptr_gray;

always @(posedge wclk) begin
    wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
end

always @(posedge rclk) begin
    rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
end

// Full and empty signals
always @(posedge wclk) begin
    wfull_reg <= (wptr_gray == (~rptr_syn[$clog2(DEPTH)-1] & rptr_syn[$clog2(DEPTH)-2:0]));
end

always @(posedge rclk) begin
    rempty_reg <= (rptr_gray == wptr_syn);
end

// Input and output connections
dual_port_RAM u_ram (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata)
);

assign wfull = wfull_reg;
assign rempty = rempty_reg;

endmodule