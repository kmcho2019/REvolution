module asyn_fifo #(
    parameter WIDTH = 8,
    parameter DEPTH = 16
)(
    input  wire         wclk, 
    input  wire         rclk, 
    input  wire         wrstn, 
    input  wire         rrstn, 
    input  wire         winc, 
    input  wire         rinc, 
    input  wire [WIDTH-1:0] wdata, 
    output wire         wfull, 
    output wire         rempty, 
    output wire [WIDTH-1:0] rdata
);

reg [WIDTH-1:0] ram_mem [DEPTH-1:0];

// Dual-port RAM module
always @(posedge wclk) begin
    if (~wrstn) begin
        ram_mem[0] <= 0;
    end else if (winc) begin
        ram_mem[waddr_bin] <= wdata;
    end
end

// Write controller
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
end

// Write pointer to Gray code conversion
always @(posedge wclk) begin
    wptr <= waddr_bin ^ (waddr_bin >> 1);
end

// Write pointer synchronizer
reg [$clog2(DEPTH)-1:0] wptr_syn;
reg [$clog2(DEPTH)-1:0] wptr_syn_buff;

always @(posedge rclk) begin
    wptr_syn_buff <= wptr_syn;
end

always @(posedge rclk) begin
    wptr_syn <= wptr_syn_buff;
end

// Read controller
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
end

// Read pointer to Gray code conversion
always @(posedge rclk) begin
    rptr <= raddr_bin ^ (raddr_bin >> 1);
end

// Read pointer synchronizer
reg [$clog2(DEPTH)-1:0] rptr_syn;
reg [$clog2(DEPTH)-1:0] rptr_syn_buff;

always @(posedge wclk) begin
    rptr_syn_buff <= rptr_syn;
end

always @(posedge wclk) begin
    rptr_syn <= rptr_syn_buff;
end

// Empty and full signals
assign wfull = (wptr == ({~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]});
assign rempty = (rptr == wptr_syn);

// Read data output
assign rdata = ram_mem[raddr_bin];

endmodule