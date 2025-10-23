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
module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input rstn,
    input wrstn,
    input rrstn,
    input winc,
    input rinc,
    input [WIDTH-1:0] wdata,
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] rdata_reg;

// Dual-port RAM instantiation
dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) RAM (
    .wclk(wclk),
    .wenc(winc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(raddr_bin),
    .rdata(rdata_reg)
);

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_buff;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;

always @(posedge wclk) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    waddr_bin_buff <= waddr_bin;
end

always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

always @(posedge wclk) begin
    wptr_buff <= wptr;
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin_buff;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_buff;

always @(posedge rclk) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    raddr_bin_buff <= raddr_bin;
end

always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// Two-stage synchronizer for read pointer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn_buff;

always @(posedge wclk) begin
    rptr_syn_buff <= rptr_buff;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_syn_buff;
end

// Two-stage synchronizer for write pointer
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_syn_buff;

always @(posedge rclk) begin
    wptr_syn_buff <= wptr_buff;
end

always @(posedge rclk) begin
    wptr_syn <= wptr_syn_buff;
end

// Full and empty logic
always @(*) begin
    if (wptr_syn == {~rptr[3], rptr[2:0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(*) begin
    if (rptr == wptr_syn) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

// Output assignment
assign rdata = rdata_reg;

endmodule