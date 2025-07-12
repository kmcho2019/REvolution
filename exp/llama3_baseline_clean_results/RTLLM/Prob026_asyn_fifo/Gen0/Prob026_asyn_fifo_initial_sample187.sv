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
    output reg wfull,
    output reg rempty,
    output reg [WIDTH-1:0] rdata
);

// Dual-port RAM
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

// Instantiation of dual-port RAM
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) dual_port_RAM_inst (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr),
   .rdata(rdata)
);

// Write and read pointers
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
reg [3:0] wptr;
reg [3:0] rptr;

always @(posedge wclk) begin
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-1] ^ waddr_bin[$clog2(DEPTH)-2], waddr_bin[$clog2(DEPTH)-2] ^ waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]};
end

always @(posedge rclk) begin
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-1] ^ raddr_bin[$clog2(DEPTH)-2], raddr_bin[$clog2(DEPTH)-2] ^ raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]};
end

// Pointer synchronizers
reg [3:0] wptr_syn;
reg [3:0] rptr_syn;

always @(posedge rclk) begin
    rptr_syn <= wptr;
end

always @(posedge wclk) begin
    wptr_syn <= rptr;
end

// Full and empty signals
always @(posedge wclk) begin
    if (wptr_syn == {~rptr[3], rptr[2:0]}) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

always @(posedge rclk) begin
    if (rptr_syn == wptr) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Input and output connections
reg wen;
reg ren;

assign wen = winc;
assign ren = rinc;

assign waddr = waddr_bin[$clog2(DEPTH)-1:0];
assign raddr = raddr_bin[$clog2(DEPTH)-1:0];

endmodule