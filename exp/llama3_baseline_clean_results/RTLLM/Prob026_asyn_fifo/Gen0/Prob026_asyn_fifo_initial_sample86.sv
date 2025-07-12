module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
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
        end
    end
endmodule

// Asynchronous FIFO module
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr, rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
reg wfull, rempty;
reg [WIDTH-1:0] rdata_out;

always @(posedge wclk) begin
    if (~wrstn) begin
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
    wptr <= waddr_bin ^ (waddr_bin >> 1);
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
    rptr_buff <= rptr;
end

always @(posedge wclk) begin
    wfull <= (wptr == (~rptr_buff[$clog2(DEPTH)-1:1] << 1) | rptr_buff[0]);
end

always @(posedge rclk) begin
    rempty <= (rptr == wptr_buff);
end

dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata_out)
);

assign rdata = rdata_out;

endmodule