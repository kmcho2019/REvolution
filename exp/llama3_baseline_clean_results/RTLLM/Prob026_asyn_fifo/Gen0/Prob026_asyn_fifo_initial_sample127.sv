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

parameter DEPTH = 16;
parameter WIDTH = 8;

// dual-port RAM
reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];
reg [WIDTH-1:0] rdata_reg;

always @(posedge wclk) begin
    if (~wrstn) begin
        for (int i = 0; i < DEPTH; i++) begin
            RAM_MEM[i] <= 0;
        end
    end else if (winc) begin
        RAM_MEM[waddr_bin] <= wdata;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        rdata_reg <= 0;
    end else if (rinc) begin
        rdata_reg <= RAM_MEM[raddr_bin];
    end
end

assign rdata = rdata_reg;

// write controller
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else begin
        if (winc) begin
            waddr_bin <= waddr_bin + 1;
            wptr_bin <= wptr_bin + 1;
            wptr_buff <= wptr_bin;
        end
        wptr <= wptr_buff;
    end
end

// read controller
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] rptr_bin;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_buff;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_bin <= 0;
        rptr <= 0;
        rptr_buff <= 0;
    end else begin
        if (rinc) begin
            raddr_bin <= raddr_bin + 1;
            rptr_bin <= rptr_bin + 1;
            rptr_buff <= rptr_bin;
        end
        rptr <= rptr_buff;
    end
end

// Gray code conversion
assign wptr_bin[$clog2(DEPTH)-1:1] = wptr_bin[$clog2(DEPTH)-1:1] ^ (wptr_bin[$clog2(DEPTH)-1:1] >> 1);
assign wptr_bin[0] = wptr_bin[0] ^ (wptr_bin[0] >> 1);
assign rptr_bin[$clog2(DEPTH)-1:1] = rptr_bin[$clog2(DEPTH)-1:1] ^ (rptr_bin[$clog2(DEPTH)-1:1] >> 1);
assign rptr_bin[0] = rptr_bin[0] ^ (rptr_bin[0] >> 1);

// read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        rptr_syn <= 0;
        rptr_syn_buff <= 0;
    end else begin
        rptr_syn_buff <= rptr;
        rptr_syn <= rptr_syn_buff;
    end
end

// write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_syn_buff;

always @(posedge rclk) begin
    if (~rrstn) begin
        wptr_syn <= 0;
        wptr_syn_buff <= 0;
    end else begin
        wptr_syn_buff <= wptr;
        wptr_syn <= wptr_syn_buff;
    end
end

// full and empty signals
assign wfull = (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr_syn);

endmodule