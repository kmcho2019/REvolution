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

// Dual-port RAM module
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        RAM_MEM[0] <= 0;
    end else if (winc) begin
        RAM_MEM[$clog2(DEPTH)-1:0] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rdata_reg <= 0;
    end else if (rinc) begin
        rdata_reg <= RAM_MEM[$clog2(DEPTH)-1:0];
    end
end

// Write pointer controller
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] waddr_bin_prev;
reg [2:0] wptr;
reg [2:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        waddr_bin_prev <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else begin
        waddr_bin_prev <= waddr_bin;
        if (winc) begin
            waddr_bin <= waddr_bin + 1;
        end
        wptr <= {waddr_bin_prev[2] ^ waddr_bin[2], waddr_bin[1:0]};
        wptr_buff <= {wptr[2], wptr[1:0]};
    end
end

// Read pointer controller
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin_prev;
reg [2:0] rptr;
reg [2:0] rptr_buff;
reg [2:0] rptr_syn;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        raddr_bin_prev <= 0;
        rptr <= 0;
        rptr_buff <= 0;
    end else begin
        raddr_bin_prev <= raddr_bin;
        if (rinc) begin
            raddr_bin <= raddr_bin + 1;
        end
        rptr <= {raddr_bin_prev[2] ^ raddr_bin[2], raddr_bin[1:0]};
        rptr_buff <= {rptr[2], rptr[1:0]};
    end
end

// Read pointer synchronizer
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// Write pointer synchronizer
reg [2:0] wptr_syn;

always @(posedge rclk) begin
    wptr_syn <= wptr_buff;
end

// Full and empty signals
assign wfull = (wptr_syn == ~rptr_syn[2] & {rptr_syn[1:0]});
assign rempty = (rptr_syn == wptr_syn);

// Output connection
assign rdata = rdata_reg;

endmodule