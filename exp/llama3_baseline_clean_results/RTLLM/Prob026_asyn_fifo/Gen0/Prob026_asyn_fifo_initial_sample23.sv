module asyn_fifo(
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

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] ram_mem [DEPTH-1:0];
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [2:0] wptr;
reg [2:0] rptr;
reg [2:0] wptr_syn;
reg [2:0] rptr_syn;
reg [2:0] wptr_buff;
reg [2:0] rptr_buff;
reg wfull_reg;
reg rempty_reg;
reg wen;
reg ren;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
        wfull_reg <= 0;
    end
    else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        if (waddr_bin == DEPTH-1) begin
            waddr_bin <= 0;
        end
    end
    wptr_buff <= wptr;
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
        rempty_reg <= 1;
    end
    else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        if (raddr_bin == DEPTH-1) begin
            raddr_bin <= 0;
        end
    end
    rptr_buff <= rptr;
end

always @(posedge wclk) begin
    wptr[2] <= waddr_bin[2] ^ waddr_bin[1];
    wptr[1] <= waddr_bin[1] ^ waddr_bin[0];
    wptr[0] <= waddr_bin[0];
    if (winc) begin
        ram_mem[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    rptr[2] <= raddr_bin[2] ^ raddr_bin[1];
    rptr[1] <= raddr_bin[1] ^ raddr_bin[0];
    rptr[0] <= raddr_bin[0];
end

always @(posedge wclk) begin
    if (~wrstn) begin
        wptr_syn <= 0;
    end
    else begin
        wptr_syn <= wptr_buff;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rptr_syn <= 0;
    end
    else begin
        rptr_syn <= rptr_buff;
    end
end

always @(posedge wclk) begin
    if (~wrstn) begin
        wfull_reg <= 0;
    end
    else begin
        wfull_reg <= (wptr_syn == (~rptr_syn[2] & rptr_syn[1:0])) ? 1 : 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rempty_reg <= 1;
    end
    else begin
        rempty_reg <= (rptr_syn == wptr_syn) ? 1 : 0;
    end
end

always @(posedge rclk) begin
    if (rempty_reg) begin
        rdata <= 0;
    end
    else begin
        rdata <= ram_mem[raddr_bin];
    end
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

endmodule