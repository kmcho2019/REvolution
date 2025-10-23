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

localparam ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM submodule
dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) ram_inst (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr_bin[$clog2(DEPTH)-1:0]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr_bin[$clog2(DEPTH)-1:0]),
    .rdata(rdata)
);

reg [ADDR_WIDTH-1:0] waddr_bin;
reg [ADDR_WIDTH-1:0] raddr_bin;
reg [ADDR_WIDTH-1:0] wptr;
reg [ADDR_WIDTH-1:0] rptr;
reg [ADDR_WIDTH-1:0] wptr_syn;
reg [ADDR_WIDTH-1:0] rptr_syn;
reg [ADDR_WIDTH-1:0] wptr_buff;
reg [ADDR_WIDTH-1:0] rptr_buff;
reg wen;
reg ren;

// Write pointer increment
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer increment
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Write pointer synchronizer
always @(posedge wclk) begin
    wptr_syn <= wptr;
end
always @(posedge rclk) begin
    wptr_buff <= wptr_syn;
end

// Read pointer synchronizer
always @(posedge rclk) begin
    rptr_syn <= rptr;
end
always @(posedge wclk) begin
    rptr_buff <= rptr_syn;
end

// Full and empty signals
always @(posedge wclk) begin
    wfull <= (wptr_buff == ({~rptr_syn[ADDR_WIDTH-1], rptr_syn[ADDR_WIDTH-2:0]}));
end

always @(posedge rclk) begin
    rempty <= (rptr_syn == wptr_buff);
end

// Enable signals for write and read operations
always @(posedge wclk) begin
    wen <= winc & ~wfull;
end

always @(posedge rclk) begin
    ren <= rinc & ~rempty;
end

endmodule

// Dual-port RAM submodule
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input wclk,
    input wenc,
    input [ADDR_WIDTH-1:0] waddr,
    input [WIDTH-1:0] wdata,
    input rclk,
    input renc,
    input [ADDR_WIDTH-1:0] raddr,
    output reg [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule