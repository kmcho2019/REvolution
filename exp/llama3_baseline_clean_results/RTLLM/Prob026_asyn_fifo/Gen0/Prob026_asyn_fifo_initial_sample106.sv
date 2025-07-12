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

// Dual-port RAM
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

// Instantiate dual-port RAM
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) RAM (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);

// Write pointer
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2]^waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-3]^waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-4]^waddr_bin[$clog2(DEPTH)-3]};
    wptr_buff <= wptr;
end

// Read pointer
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_syn;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2]^raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-3]^raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-4]^raddr_bin[$clog2(DEPTH)-3]};
    rptr_buff <= rptr;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Write enable
reg wen;

always @(posedge wclk) begin
    if (wfull) begin
        wen <= 0;
    end else if (winc) begin
        wen <= 1;
    end else begin
        wen <= 0;
    end
end

// Read enable
reg ren;

always @(posedge rclk) begin
    if (rempty) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end else begin
        ren <= 0;
    end
end

// Full signal
reg wfull;

always @(posedge wclk) begin
    if (wptr_buff == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

// Empty signal
reg rempty;

always @(posedge rclk) begin
    if (rptr_buff == wptr_buff) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Assign addresses
assign waddr = waddr_bin[$clog2(DEPTH)-2:0];
assign raddr = rptr_syn[$clog2(DEPTH)-2:0];

endmodule