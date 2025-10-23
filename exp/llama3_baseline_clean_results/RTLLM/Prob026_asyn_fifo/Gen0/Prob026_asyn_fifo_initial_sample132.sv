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

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [2:0] wptr;
reg [2:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= {waddr_bin[2] ^ waddr_bin[1], waddr_bin[1] ^ waddr_bin[0], waddr_bin[0]};
        wptr_buff <= wptr;
    end else begin
        wptr_buff <= wptr;
    end
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [2:0] rptr;
reg [2:0] rptr_buff;
reg [2:0] rptr_syn;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= {raddr_bin[2] ^ raddr_bin[1], raddr_bin[1] ^ raddr_bin[0], raddr_bin[0]};
        rptr_buff <= rptr;
    end else begin
        rptr_buff <= rptr;
    end
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Dual-port RAM
always @(posedge wclk) begin
    if (winc) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (rinc) begin
        rdata <= RAM_MEM[raddr_bin];
    end
end

// Full and empty signal generation
assign wfull = (wptr == (~rptr_syn[2] & rptr_syn[1:0])) ? 1'b1 : 1'b0;
assign rempty = (rptr == wptr) ? 1'b1 : 1'b0;

endmodule