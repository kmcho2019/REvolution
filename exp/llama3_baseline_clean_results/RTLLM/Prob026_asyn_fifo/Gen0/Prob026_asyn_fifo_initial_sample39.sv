// Dual-port RAM module
module dual_port_RAM(
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

// Asynchronous FIFO module
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

// Instantiate dual-port RAM
dual_port_RAM RAM(
    .wclk(wclk), 
    .wenc(wen), 
    .waddr(waddr_bin), 
    .wdata(wdata), 
    .rclk(rclk), 
    .renc(ren), 
    .raddr(raddr_bin), 
    .rdata(rdata_out)
);

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] wptr;
reg [$clog2(DEPTH)-1:0] wptr_buff;

always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr_buff <= wptr;
    wptr <= {waddr_bin[$clog2(DEPTH)-1], waddr_bin[$clog2(DEPTH)-2]^waddr_bin[$clog2(DEPTH)-3], waddr_bin[$clog2(DEPTH)-3]^waddr_bin[$clog2(DEPTH)-4], waddr_bin[$clog2(DEPTH)-4]};
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] rptr;
reg [$clog2(DEPTH)-1:0] rptr_buff;

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    rptr_buff <= rptr;
    rptr <= {raddr_bin[$clog2(DEPTH)-1], raddr_bin[$clog2(DEPTH)-2]^raddr_bin[$clog2(DEPTH)-3], raddr_bin[$clog2(DEPTH)-3]^raddr_bin[$clog2(DEPTH)-4], raddr_bin[$clog2(DEPTH)-4]};
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn_buff;

always @(posedge wclk) begin
    rptr_syn_buff <= rptr_syn;
    rptr_syn <= rptr_buff;
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_syn_buff;

always @(posedge rclk) begin
    wptr_syn_buff <= wptr_syn;
    wptr_syn <= wptr_buff;
end

// Empty and full signals
assign wfull = (wptr_syn == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr_syn == wptr_syn);

// Enable signals
reg wen;
reg ren;

always @(posedge wclk) begin
    if (~wrstn) begin
        wen <= 0;
    end else if (winc) begin
        wen <= 1;
    end else begin
        wen <= 0;
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        ren <= 0;
    end else if (rinc) begin
        ren <= 1;
    end else begin
        ren <= 0;
    end
end

// Output signals
assign rdata = rdata_out;

endmodule