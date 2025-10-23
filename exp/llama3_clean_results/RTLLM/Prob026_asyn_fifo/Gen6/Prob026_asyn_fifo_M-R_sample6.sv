module dual_port_ram #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
)(
    input wclk,
    input rclk,
    input wrstn,
    input rrstn,
    input [WIDTH-1:0] wdata,
    input waddr,
    input raddr,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always @(posedge wclk) begin
    if (~wrstn) begin
        RAM_MEM[waddr] <= 0;
    end else if (wdata != 0) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rdata <= 0;
    end else begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule

module gray_code #(
    parameter WIDTH = 4
)(
    input [WIDTH-1:0] bin,
    output reg [WIDTH-1:0] gray
);

always @(*) begin
    gray = bin ^ (bin >> 1);
end

endmodule

module write_controller #(
    parameter DEPTH = 16
)(
    input wclk,
    input wrstn,
    input winc,
    input [DEPTH-1:0] wdata,
    output reg [DEPTH-1:0] waddr,
    output reg wfull
);

reg [DEPTH-1:0] waddr_bin;
reg [DEPTH-1:0] wptr;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wfull <= 0;
    end else if (winc && ~wfull) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= waddr_bin;
    end
end

assign waddr = waddr_bin;

endmodule

module read_controller #(
    parameter DEPTH = 16
)(
    input rclk,
    input rrstn,
    input rinc,
    output reg [DEPTH-1:0] raddr,
    output reg rempty
);

reg [DEPTH-1:0] raddr_bin;
reg [DEPTH-1:0] rptr;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rempty <= 1;
    end else if (rinc && ~rempty) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= raddr_bin;
    end
end

assign raddr = raddr_bin;

endmodule

module synchronizer #(
    parameter WIDTH = 4
)(
    input clk,
    input [WIDTH-1:0] data,
    output reg [WIDTH-1:0] sync_data
);

reg [WIDTH-1:0] sync_data1;
reg [WIDTH-1:0] sync_data2;

always @(posedge clk) begin
    sync_data1 <= data;
    sync_data2 <= sync_data1;
    sync_data <= sync_data2;
end

endmodule

module asyn_fifo #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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

wire [DEPTH-1:0] waddr;
wire [DEPTH-1:0] raddr;
wire [WIDTH-1:0] wdata_ram;
wire [WIDTH-1:0] rdata_ram;

dual_port_ram #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram (
    .wclk(wclk),
    .rclk(rclk),
    .wrstn(wrstn),
    .rrstn(rrstn),
    .wdata(wdata),
    .waddr(waddr),
    .raddr(raddr),
    .rdata(rdata_ram)
);

write_controller #(.DEPTH(DEPTH)) write_ctrl (
    .wclk(wclk),
    .wrstn(wrstn),
    .winc(winc),
    .wdata(wdata),
    .waddr(waddr),
    .wfull(wfull)
);

read_controller #(.DEPTH(DEPTH)) read_ctrl (
    .rclk(rclk),
    .rrstn(rrstn),
    .rinc(rinc),
    .raddr(raddr),
    .rempty(rempty)
);

synchronizer #(.WIDTH($clog2(DEPTH))) wptr_sync (
    .clk(rclk),
    .data(waddr),
    .sync_data(waddr)
);

synchronizer #(.WIDTH($clog2(DEPTH))) rptr_sync (
    .clk(wclk),
    .data(raddr),
    .sync_data(raddr)
);

gray_code #(.WIDTH($clog2(DEPTH))) wptr_gray (
    .bin(waddr),
    .gray()
);

gray_code #(.WIDTH($clog2(DEPTH))) rptr_gray (
    .bin(raddr),
    .gray()
);

assign rdata = rdata_ram;

endmodule