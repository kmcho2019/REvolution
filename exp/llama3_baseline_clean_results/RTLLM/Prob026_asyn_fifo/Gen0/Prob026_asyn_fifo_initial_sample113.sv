module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  rclk,
    input  wrstn,
    input  rrstn,
    input  winc,
    input  rinc,
    input  [WIDTH-1:0] wdata,
    output reg [WIDTH-1:0] rdata,
    output reg wfull,
    output reg rempty
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wclk,
    input  wenc,
    input  [$clog2(DEPTH)-1:0] waddr,
    input  [WIDTH-1:0] wdata,
    input  rclk,
    input  renc,
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

// Instantiation of the dual-port RAM module
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin),
    .rdata(rdata)
);

// Write and read pointer management
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;

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

// Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;

always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1:1], ~(waddr_bin[0])};
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1:1], ~(raddr_bin[0])};
end

// Buffer registers for pointer synchronization
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Full and empty signal generation
reg wfull;
reg rempty;

always @(*) begin
    wfull = (wptr == {~rptr[$clog2(DEPTH)-1], rptr[$clog2(DEPTH)-2:0]});
    rempty = (rptr == wptr);
end

// Write enable signal generation
reg wenc;

always @(*) begin
    wenc = winc && ~wfull;
end

// Read enable signal generation
reg renc;

always @(*) begin
    renc = rinc && ~rempty;
end

endmodule