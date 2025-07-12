module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input wclk,  // Write clock
    input rclk,  // Read clock
    input wrstn, // Write reset (active low)
    input rrstn, // Read reset (active low)
    input winc,  // Write increment
    input rinc,  // Read increment
    input [WIDTH-1:0] wdata, // Write data
    output wfull, // Write full
    output rempty, // Read empty
    output [WIDTH-1:0] rdata // Read data
);

// Dual-port RAM module
module dual_port_RAM #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)
(
    input wclk, // Write clock
    input wenc, // Write enable
    input [$clog2(DEPTH)-1:0] waddr, // Write address
    input [WIDTH-1:0] wdata, // Write data
    input rclk, // Read clock
    input renc, // Read enable
    input [$clog2(DEPTH)-1:0] raddr, // Read address
    output [WIDTH-1:0] rdata // Read data
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0]; // RAM memory

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

// Instantiate dual-port RAM
dual_port_RAM #(
   .WIDTH(WIDTH),
   .DEPTH(DEPTH)
) RAM (
   .wclk(wclk),
   .wenc(wen),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(ren),
   .raddr(raddr_bin),
   .rdata(rdata)
);

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin; // Binary write address
reg [$clog2(DEPTH)-1:0] wptr; // Gray code write pointer
reg [$clog2(DEPTH)-1:0] wptr_buff; // Buffered write pointer

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= (waddr_bin >> 1) ^ waddr_bin;
        wptr_buff <= wptr;
    end
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin; // Binary read address
reg [$clog2(DEPTH)-1:0] rptr; // Gray code read pointer
reg [$clog2(DEPTH)-1:0] rptr_syn; // Synchronized read pointer
reg [$clog2(DEPTH)-1:0] rptr_buff; // Buffered read pointer

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rptr_syn <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= (raddr_bin >> 1) ^ raddr_bin;
        rptr_syn <= wptr_buff; // Synchronize read pointer with write clock domain
        rptr_buff <= rptr;
    end
end

// Empty and full detection
assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr);

// Control signals
assign wen = winc;
assign ren = rinc;

endmodule