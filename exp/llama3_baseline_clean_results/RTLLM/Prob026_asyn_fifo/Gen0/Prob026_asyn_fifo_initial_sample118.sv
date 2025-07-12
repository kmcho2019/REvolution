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
    output wfull,
    output rempty,
    output [WIDTH-1:0] rdata
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16,
    parameter WIDTH = 8
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
    reg [WIDTH-1:0] rdata_reg;

    always @(posedge wclk) begin
        if (wenc) begin
            RAM_MEM[waddr] <= wdata;
        end
    end

    always @(posedge rclk) begin
        if (renc) begin
            rdata_reg <= RAM_MEM[raddr];
        end
        rdata <= rdata_reg;
    end

endmodule

// Asynchronous FIFO module
reg [WIDTH-1:0] RAM_RDATA;
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [1:0] wptr_gray;
reg [1:0] rptr_gray;
reg [1:0] wptr_buff;
reg [1:0] rptr_buff;
reg wfull_reg;
reg rempty_reg;

// Dual-port RAM instantiation
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) dual_port_RAM_inst (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(RAM_RDATA)
);

// Write pointer logic
always @(posedge wclk) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr_gray <= waddr_bin[1:0] ^ (waddr_bin[1:0] >> 1);
end

always @(posedge rclk) begin
    rptr_gray <= raddr_bin[1:0] ^ (raddr_bin[1:0] >> 1);
end

// Pointer buffers
always @(posedge wclk) begin
    if (!wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr_gray;
    end
end

always @(posedge rclk) begin
    if (!rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr_gray;
    end
end

// Full and empty signals
always @(posedge wclk) begin
    if (wptr_gray == {~rptr_buff[1], rptr_buff[0]}) begin
        wfull_reg <= 1'b1;
    end else begin
        wfull_reg <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr_gray == wptr_buff) begin
        rempty_reg <= 1'b1;
    end else begin
        rempty_reg <= 1'b0;
    end
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;
assign rdata = RAM_RDATA;

endmodule