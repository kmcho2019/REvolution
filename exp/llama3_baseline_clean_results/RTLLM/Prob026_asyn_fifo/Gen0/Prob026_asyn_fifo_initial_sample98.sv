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

// Dual-port RAM module
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

// Write pointer
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [2:0] wptr;
reg [2:0] wptr_buff;

// Read pointer
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [2:0] rptr;
reg [2:0] rptr_buff;
reg [2:0] rptr_syn;

// Gray code conversion
always @(posedge wclk) begin
    waddr_bin <= (waddr_bin + 1) % DEPTH;
    wptr <= {waddr_bin[2], waddr_bin[2]^waddr_bin[1], waddr_bin[1]^waddr_bin[0]};
    wptr_buff <= wptr;
end

always @(posedge rclk) begin
    raddr_bin <= (raddr_bin + 1) % DEPTH;
    rptr <= {raddr_bin[2], raddr_bin[2]^raddr_bin[1], raddr_bin[1]^raddr_bin[0]};
    rptr_buff <= rptr;
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Write pointer synchronizer
always @(posedge rclk) begin
    wptr_buff <= wptr_buff;
end

// Full and empty signals
assign wfull = (wptr == {~rptr_syn[2], rptr_syn[1:0]});
assign rempty = (rptr == wptr);

// Input and output connections
dual_port_RAM #(.WIDTH(WIDTH),.DEPTH(DEPTH)) RAM (
   .wclk(wclk),
   .wenc(winc),
   .waddr(waddr_bin[2:0]),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc),
   .raddr(raddr_bin[2:0]),
   .rdata(rdata)
);

endmodule