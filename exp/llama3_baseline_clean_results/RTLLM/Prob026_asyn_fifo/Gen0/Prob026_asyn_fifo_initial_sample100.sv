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

// Dual-port RAM module instantiation
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
        end
    end

endmodule

// Asynchronous FIFO module implementation
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn;

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
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1]^waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-2]^waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]};
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1]^raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-2]^raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]};
    rptr_buff <= rptr;
    wptr_syn <= wptr_buff;
    rptr_syn <= rptr_buff;
end

always @(posedge wclk) begin
    if (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr_syn) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) u_dual_port_RAM (
    .wclk(wclk),
    .wenc(~wfull & winc),
    .waddr(waddr_bin[2:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(~rempty & rinc),
    .raddr(raddr_bin[2:0]),
    .rdata(rdata)
);

endmodule