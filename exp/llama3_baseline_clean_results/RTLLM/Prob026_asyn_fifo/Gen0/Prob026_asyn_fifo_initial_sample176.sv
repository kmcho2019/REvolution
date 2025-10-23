module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic           wclk,
    input  logic           rclk,
    input  logic           wrstn,
    input  logic           rrstn,
    input  logic           winc,
    input  logic           rinc,
    input  logic [WIDTH-1:0] wdata,
    output logic           wfull,
    output logic           rempty,
    output logic [WIDTH-1:0] rdata
);

localparam ADDR_WIDTH = $clog2(DEPTH);

// Dual-port RAM
logic [WIDTH-1:0] ram_rdata;
logic [WIDTH-1:0] ram_wdata;
logic           ram_wen;
logic           ram_ren;
logic [ADDR_WIDTH-1:0] ram_waddr;
logic [ADDR_WIDTH-1:0] ram_raddr;

dual_port_RAM #(
    .WIDTH(WIDTH),
    .DEPTH(DEPTH)
) dual_port_ram (
    .wclk(wclk),
    .wenc(ram_wen),
    .waddr(ram_waddr),
    .wdata(ram_wdata),
    .rclk(rclk),
    .renc(ram_ren),
    .raddr(ram_raddr),
    .rdata(ram_rdata)
);

// Write pointer
logic [ADDR_WIDTH-1:0] waddr_bin;
logic [ADDR_WIDTH-1:0] wptr_gray;
logic [ADDR_WIDTH-1:0] wptr_gray_syn;

always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

assign wptr_gray = (waddr_bin >> 1) ^ waddr_bin;

// Read pointer
logic [ADDR_WIDTH-1:0] raddr_bin;
logic [ADDR_WIDTH-1:0] rptr_gray;
logic [ADDR_WIDTH-1:0] rptr_gray_syn;

always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

assign rptr_gray = (raddr_bin >> 1) ^ raddr_bin;

// Pointer synchronizers
always_ff @(posedge wclk) begin
    wptr_gray_syn <= wptr_gray;
end

always_ff @(posedge rclk) begin
    rptr_gray_syn <= rptr_gray;
end

// Full and empty signals
assign wfull = (wptr_gray_syn[ADDR_WIDTH-1] != rptr_gray[ADDR_WIDTH-1]) &&
               (wptr_gray_syn[ADDR_WIDTH-2:0] == rptr_gray[ADDR_WIDTH-2:0]);

assign rempty = (wptr_gray_syn == rptr_gray);

// RAM control signals
assign ram_wdata = wdata;
assign ram_waddr = waddr_bin[ADDR_WIDTH-1:0];
assign ram_raddr = raddr_bin[ADDR_WIDTH-1:0];
assign ram_wen = winc;
assign ram_ren = rinc;

// Output signals
assign rdata = ram_rdata;

endmodule

module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
) (
    input  logic           wclk,
    input  logic           wenc,
    input  logic [$clog2(DEPTH)-1:0] waddr,
    input  logic [WIDTH-1:0] wdata,
    input  logic           rclk,
    input  logic           renc,
    input  logic [$clog2(DEPTH)-1:0] raddr,
    output logic [WIDTH-1:0] rdata
);

logic [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

always_ff @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always_ff @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end else begin
        rdata <= 0;
    end
end

endmodule