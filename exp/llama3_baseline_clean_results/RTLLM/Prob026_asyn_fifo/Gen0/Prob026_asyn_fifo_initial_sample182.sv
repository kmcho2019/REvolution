module asyn_fifo(
    input             wclk,
    input             rclk,
    input             wrstn,
    input             rrstn,
    input             winc,
    input             rinc,
    input  [WIDTH-1:0] wdata,
    output reg         wfull,
    output reg         rempty,
    output reg [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Dual-port RAM module
reg [WIDTH-1:0] rdata_reg;
reg [WIDTH-1:0] wdata_reg;
reg [WIDTH-1:0] raddr_bin;
reg [WIDTH-1:0] waddr_bin;
reg               wenc;
reg               renc;

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

wire [$clog2(DEPTH)-1:0] waddr = waddr_bin[$clog2(DEPTH)-1:0];
wire [$clog2(DEPTH)-1:0] raddr = raddr_bin[$clog2(DEPTH)-1:0];

// Write data controller
always @(posedge wclk) begin
    if (~wrstn) begin
        wenc <= 0;
        wdata_reg <= 0;
    end else if (winc) begin
        wenc <= 1;
        wdata_reg <= wdata;
    end else begin
        wenc <= 0;
    end
end

// Read data controller
always @(posedge rclk) begin
    if (~rrstn) begin
        renc <= 0;
    end else if (rinc) begin
        renc <= 1;
    end else begin
        renc <= 0;
    end
end

// Dual-port RAM
dual_port_RAM RAM (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr),
    .wdata(wdata_reg),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr),
    .rdata(rdata_reg)
);

assign rdata = rdata_reg;

// Read pointer synchronizer
reg [1:0] rptr_syn;
reg [1:0] rptr_syn_reg;
always @(posedge wclk) begin
    rptr_syn_reg <= raddr_bin[$clog2(DEPTH)-1:1];
end
always @(posedge wclk) begin
    rptr_syn <= rptr_syn_reg;
end

// Write pointer synchronizer
reg [1:0] wptr_syn;
reg [1:0] wptr_syn_reg;
always @(posedge rclk) begin
    wptr_syn_reg <= waddr_bin[$clog2(DEPTH)-1:1];
end
always @(posedge rclk) begin
    wptr_syn <= wptr_syn_reg;
end

// Empty and full signals
always @(posedge wclk) begin
    if (waddr_bin[$clog2(DEPTH)-1:0] == {~rptr_syn[1], rptr_syn[0]}) begin
        wfull <= 1;
    end else begin
        wfull <= 0;
    end
end

always @(posedge rclk) begin
    if (raddr_bin[$clog2(DEPTH)-1:0] == wptr_syn) begin
        rempty <= 1;
    end else begin
        rempty <= 0;
    end
end

endmodule

module dual_port_RAM(
    input             wclk,
    input             wenc,
    input [$clog2(DEPTH)-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input             rclk,
    input             renc,
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
    end else begin
        rdata <= 0;
    end
end

endmodule