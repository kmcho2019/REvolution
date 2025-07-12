module asyn_fifo (
    input  wclk, 
    input  rclk, 
    input  wrstn, 
    input  rrstn, 
    input  winc, 
    input  rinc, 
    input  [WIDTH-1:0] wdata, 
    output wfull, 
    output rempty, 
    output [WIDTH-1:0] rdata
);

parameter DEPTH = 16;
parameter WIDTH = 8;

// dual-port RAM submodule
module dual_port_RAM (
    input  wclk, 
    input  wenc, 
    input  [$clog2(DEPTH)-1:0] waddr, 
    input  [WIDTH-1:0] wdata, 
    input  rclk, 
    input  renc, 
    input  [$clog2(DEPTH)-1:0] raddr, 
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

// write pointer binary register
reg [$clog2(DEPTH)-1:0] waddr_bin;
always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// read pointer binary register
reg [$clog2(DEPTH)-1:0] raddr_bin;
always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
reg [$clog2(DEPTH)-1:0] wptr;
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Gray code conversion for read pointer
reg [$clog2(DEPTH)-1:0] rptr;
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// write pointer buffer
reg [$clog2(DEPTH)-1:0] wptr_buff;
always @(posedge wclk) begin
    wptr_buff <= wptr;
end

// read pointer buffer
reg [$clog2(DEPTH)-1:0] rptr_buff;
always @(posedge rclk) begin
    rptr_buff <= rptr;
end

// two-stage trigger for read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
always @(posedge wclk) begin
    rptr_syn <= rptr_buff;
end

// two-stage trigger for write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
always @(posedge rclk) begin
    wptr_syn <= wptr_buff;
end

// full and empty signals
assign wfull = (wptr[$clog2(DEPTH)-1] != rptr_syn[$clog2(DEPTH)-1]) && (wptr[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);
assign rempty = (wptr == rptr_syn);

// dual-port RAM instantiation
dual_port_RAM RAM_inst (
    .wclk(wclk), 
    .wenc(winc), 
    .waddr(waddr_bin[$clog2(DEPTH)-2:0]), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(rinc), 
    .raddr(raddr_bin[$clog2(DEPTH)-2:0]), 
    .rdata(rdata)
);

endmodule