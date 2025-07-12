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

// Dual-port RAM
reg [WIDTH-1:0] ram_mem [DEPTH-1:0];

// Write and read pointers
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin_syn;

// Gray code conversion
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_syn;

// Buffer registers
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_buff;

// Full and empty signals
reg wfull_reg;
reg rempty_reg;

// Write enable and read enable
reg wen;
reg ren;

// Internal wire
reg [$clog2(DEPTH)-1:0] waddr;
reg [$clog2(DEPTH)-1:0] raddr;

assign wfull = wfull_reg;
assign rempty = rempty_reg;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr_syn;
    end
end

// Gray code conversion
always @(waddr_bin or raddr_bin_syn) begin
    wptr = (waddr_bin >> 1) ^ waddr_bin;
    rptr_syn = (raddr_bin_syn >> 1) ^ raddr_bin_syn;
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn1;
reg [$clog2(DEPTH)-1:0] wptr_syn2;

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        wptr_syn1 <= 0;
        wptr_syn2 <= 0;
    end else begin
        wptr_syn1 <= wptr;
        wptr_syn2 <= wptr_syn1;
    end
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn1;
reg [$clog2(DEPTH)-1:0] rptr_syn2;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        rptr_syn1 <= 0;
        rptr_syn2 <= 0;
    end else begin
        rptr_syn1 <= rptr;
        rptr_syn2 <= rptr_syn1;
    end
end

assign rptr_syn = rptr_syn2;

// Full and empty signals
always @(wptr_buff or rptr_syn) begin
    if (wptr_buff == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}) begin
        wfull_reg <= 1;
    end else begin
        wfull_reg <= 0;
    end
    if (rptr_syn == wptr_buff) begin
        rempty_reg <= 1;
    end else begin
        rempty_reg <= 0;
    end
end

// Write enable and read enable
assign wen = winc & ~wfull_reg;
assign ren = rinc & ~rempty_reg;

// Address calculation
assign waddr = waddr_bin[$clog2(DEPTH)-1:1];
assign raddr = raddr_bin_syn[$clog2(DEPTH)-1:1];

// Dual-port RAM
always @(posedge wclk) begin
    if (wen) begin
        ram_mem[waddr] <= wdata;
    end
end

always @(posedge rclk) begin
    if (ren) begin
        rdata <= ram_mem[raddr];
    end
end

endmodule