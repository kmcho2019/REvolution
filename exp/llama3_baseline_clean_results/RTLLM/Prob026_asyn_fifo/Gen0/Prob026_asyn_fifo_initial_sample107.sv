module asyn_fifo(
    input  wire wclk,
    input  wire rclk,
    input  wire wrstn,
    input  wire rrstn,
    input  wire winc,
    input  wire rinc,
    input  wire [WIDTH-1:0] wdata,
    output reg  wfull,
    output reg  rempty,
    output reg [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

wire [$clog2(DEPTH)-1:0] waddr, raddr;
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Dual-port RAM
always @(posedge wclk) begin
    if (~wrstn) begin
        RAM_MEM[waddr] <= 0;
    end else if (winc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    rdata <= RAM_MEM[raddr];
end

// Write and Read Pointers
reg [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin;
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

// Gray Code Conversion
reg [$clog2(DEPTH)-1:0] wptr, rptr;
always @(*) begin
    wptr = waddr_bin ^ (waddr_bin >> 1);
    rptr = raddr_bin ^ (raddr_bin >> 1);
end

// Pointer Buffers
reg [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff;
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

// Full and Empty Signals
reg wfull_reg, rempty_reg;
always @(*) begin
    wfull_reg = (wptr == (~rptr[$clog2(DEPTH)-1:1] & {1'b0, rptr[$clog2(DEPTH)-2:0]}));
    rempty_reg = (wptr == rptr);
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

// Assign addresses
assign waddr = waddr_bin[$clog2(DEPTH)-2:0];
assign raddr = rptr_buff[$clog2(DEPTH)-2:0];

endmodule