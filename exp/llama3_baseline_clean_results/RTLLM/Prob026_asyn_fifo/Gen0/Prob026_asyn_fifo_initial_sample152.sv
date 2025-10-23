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

localparam ADDR_WIDTH = $clog2(DEPTH);

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;

reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_buff1;
reg [ADDR_WIDTH-1:0] wptr_buff2;
reg [ADDR_WIDTH-1:0] rptr_buff1;
reg [ADDR_WIDTH-1:0] rptr_buff2;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr_buff1 <= waddr_bin;
end

always @(posedge wclk) begin
    wptr_buff2 <= wptr_buff1;
end

always @(posedge rclk) begin
    rptr_buff1 <= raddr_bin;
end

always @(posedge rclk) begin
    rptr_buff2 <= rptr_buff1;
end

always @(posedge wclk) begin
    wptr <= wptr_buff2;
end

always @(posedge rclk) begin
    rptr <= rptr_buff2;
end

wire [ADDR_WIDTH-1:0] wptr_gray = (wptr >> 1) ^ wptr;
wire [ADDR_WIDTH-1:0] rptr_gray = (rptr >> 1) ^ rptr;

assign wfull = (wptr_gray[ADDR_WIDTH-1] != rptr_gray[ADDR_WIDTH-1]) && (wptr_gray[ADDR_WIDTH-2:0] == rptr_gray[ADDR_WIDTH-2:0]);

assign rempty = (wptr_gray == rptr_gray);

dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) u_dual_port_RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin[ADDR_WIDTH-2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin[ADDR_WIDTH-2:0]),
    .rdata(rdata)
);

endmodule

module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input wclk,
    input wenc,
    input [$clog2(DEPTH)-2:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [$clog2(DEPTH)-2:0] raddr,
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