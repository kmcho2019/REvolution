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

reg [WIDTH-1:0] ram[DEPTH-1:0];

always @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram[raddr];
    end
end

endmodule

module write_pointer_manager #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wrstn,
    input winc,
    output reg [WIDTH-1:0] wptr_bin,
    output reg [WIDTH-1:0] wptr_gray
);

localparam ADDR_WIDTH = $clog2(DEPTH);

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;

endmodule

module read_pointer_manager #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input rclk,
    input rrstn,
    input rinc,
    output reg [WIDTH-1:0] rptr_bin,
    output reg [WIDTH-1:0] rptr_gray
);

localparam ADDR_WIDTH = $clog2(DEPTH);

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

endmodule

module full_empty_generator #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input [WIDTH-1:0] wptr_gray,
    input [WIDTH-1:0] rptr_gray,
    output reg wfull,
    output reg rempty
);

localparam ADDR_WIDTH = $clog2(DEPTH);

assign wfull = (wptr_gray[ADDR_WIDTH-1] != rptr_gray[ADDR_WIDTH-1]) && (wptr_gray[ADDR_WIDTH-2:0] == rptr_gray[ADDR_WIDTH-2:0]);
assign rempty = (rptr_gray == wptr_gray);

endmodule

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

wire [WIDTH-1:0] wptr_bin;
wire [WIDTH-1:0] wptr_gray;
wire [WIDTH-1:0] rptr_bin;
wire [WIDTH-1:0] rptr_gray;

write_pointer_manager #(.WIDTH(WIDTH), .DEPTH(DEPTH)) write_ptr(
    .wclk(wclk),
    .wrstn(wrstn),
    .winc(winc),
    .wptr_bin(wptr_bin),
    .wptr_gray(wptr_gray)
);

read_pointer_manager #(.WIDTH(WIDTH), .DEPTH(DEPTH)) read_ptr(
    .rclk(rclk),
    .rrstn(rrstn),
    .rinc(rinc),
    .rptr_bin(rptr_bin),
    .rptr_gray(rptr_gray)
);

full_empty_generator #(.WIDTH(WIDTH), .DEPTH(DEPTH)) full_empty(
    .wptr_gray(wptr_gray),
    .rptr_gray(rptr_gray),
    .wfull(wfull),
    .rempty(rempty)
);

dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram(
    .wclk(wclk),
    .wenc(winc),
    .wdata(wdata),
    .waddr(wptr_bin[WIDTH-2:0]),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_bin[WIDTH-2:0]),
    .rdata(rdata)
);

endmodule