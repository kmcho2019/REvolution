module dual_port_RAM (
    input             wclk,
    input             wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0] wdata,
    input             rclk,
    input             renc,
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

module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input             wclk,
    input             rstn,
    input             winc,
    input  [WIDTH-1:0] wdata,
    input             rclk,
    input             rrstn,
    input             rinc,
    output            wfull,
    output            rempty,
    output [WIDTH-1:0] rdata
);

reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [WIDTH-1:0] wptr_bin;
reg [WIDTH-1:0] rptr_bin;
reg [WIDTH-1:0] wptr_gray;
reg [WIDTH-1:0] rptr_gray;
reg [WIDTH-1:0] wptr_syn;
reg [WIDTH-1:0] rptr_syn;
reg             wfull_int;
reg             rempty_int;

dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) dual_port_ram (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata)
);

always @(posedge wclk) begin
    if (~rstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr_bin <= waddr_bin;
    wptr_gray <= (wptr_bin >> 1) ^ wptr_bin;
end

always @(posedge rclk) begin
    rptr_bin <= raddr_bin;
    rptr_gray <= (rptr_bin >> 1) ^ rptr_bin;
end

always @(posedge wclk) begin
    wptr_syn <= rptr_gray;
end

always @(posedge rclk) begin
    rptr_syn <= wptr_gray;
end

assign wfull_int = (wptr_gray == (~rptr_syn[$clog2(DEPTH)-1] << ($clog2(DEPTH)-1)) | (rptr_syn[$clog2(DEPTH)-2:0] == wptr_gray[$clog2(DEPTH)-2:0]));
assign rempty_int = (wptr_gray == rptr_syn);

assign wfull = wfull_int;
assign rempty = rempty_int;

endmodule