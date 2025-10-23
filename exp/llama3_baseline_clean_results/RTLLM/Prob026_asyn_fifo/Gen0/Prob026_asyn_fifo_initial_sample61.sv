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

// Dual-port RAM instantiation
dual_port_RAM #(.WIDTH(WIDTH), .DEPTH(DEPTH)) ram_instance (
    .wclk(wclk),
    .wenc(wen),
    .waddr(waddr),
    .wdata(wdata),
    .rclk(rclk),
    .renc(ren),
    .raddr(raddr),
    .rdata(rdata)
);

// Write pointer management
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_next;
reg [WIDTH-1:0] wptr;
reg [WIDTH-1:0] wptr_syn;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    waddr_bin_next <= waddr_bin;
end

assign wptr = {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2]^waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]^waddr_bin[$clog2(DEPTH)-4]};

// Read pointer management
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin_next;
reg [WIDTH-1:0] rptr;
reg [WIDTH-1:0] rptr_syn;

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    raddr_bin_next <= raddr_bin;
end

assign rptr = {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2]^raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]^raddr_bin[$clog2(DEPTH)-4]};

// Pointer synchronizers
reg [WIDTH-1:0] wptr_buff;
reg [WIDTH-1:0] rptr_buff;

always @(posedge rclk) begin
    wptr_syn <= wptr;
end

always @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Full and empty signal generation
assign wfull = (wptr_syn[$clog2(DEPTH)-1] != rptr_syn[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);
assign rempty = (rptr_syn == wptr_syn);

// Input and output connections
assign wen = winc;
assign ren = rinc;
assign waddr = waddr_bin[$clog2(DEPTH)-2:0];
assign raddr = raddr_bin[$clog2(DEPTH)-2:0];

endmodule

// Dual-port RAM submodule
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
    output [WIDTH-1:0] rdata
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