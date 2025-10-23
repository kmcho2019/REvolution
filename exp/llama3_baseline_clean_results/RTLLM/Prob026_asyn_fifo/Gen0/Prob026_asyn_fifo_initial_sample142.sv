// Dual-port RAM module
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

// Asynchronous FIFO module
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

reg [WIDTH-1:0] wdata_reg;
reg [WIDTH-1:0] rdata_reg;
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_syn;
reg [$clog2(DEPTH)-1:0] raddr_bin_syn;
reg [2:0] wptr;
reg [2:0] rptr;
reg [2:0] wptr_syn;
reg [2:0] rptr_syn;
reg wfull_reg;
reg rempty_reg;
reg wenc;
reg renc;

wire [$clog2(DEPTH)-1:0] waddr;
wire [$clog2(DEPTH)-1:0] raddr;

assign waddr = waddr_bin_syn;
assign raddr = raddr_bin_syn;

// Write pointer logic
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer logic
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion
always @(posedge wclk) begin
    wptr[2:0] <= {waddr_bin[1], waddr_bin[0] ^ waddr_bin[1], waddr_bin[0]};
end

always @(posedge rclk) begin
    rptr[2:0] <= {raddr_bin[1], raddr_bin[0] ^ raddr_bin[1], raddr_bin[0]};
end

// Pointer synchronizer
always @(posedge wclk) begin
    wptr_syn[2:0] <= wptr[2:0];
end

always @(posedge rclk) begin
    rptr_syn[2:0] <= rptr[2:0];
end

// Full and empty signals
always @(posedge wclk) begin
    wfull_reg <= (wptr[2] != rptr_syn[2]) && (wptr[1:0] == rptr_syn[1:0]);
end

always @(posedge rclk) begin
    rempty_reg <= (rptr[2:0] == wptr_syn[2:0]);
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

// Write enable logic
always @(posedge wclk) begin
    wenc <= winc && ~wfull;
end

// Read enable logic
always @(posedge rclk) begin
    renc <= rinc && ~rempty;
end

// Dual-port RAM instantiation
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) RAM (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata_reg)
);

assign rdata = rdata_reg;

endmodule