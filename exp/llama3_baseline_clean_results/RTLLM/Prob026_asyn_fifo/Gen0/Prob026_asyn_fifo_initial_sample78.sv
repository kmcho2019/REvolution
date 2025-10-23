module asyn_fifo(
    input         wclk,        // Write clock signal
    input         rclk,        // Read clock signal
    input         wrstn,       // Write reset signal
    input         rrstn,       // Read reset signal
    input         winc,        // Write increment signal
    input         rinc,        // Read increment signal
    input  [7:0]  wdata,       // Write data input
    output        wfull,       // Write full signal
    output        rempty,      // Read empty signal
    output [7:0]  rdata        // Read data output
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];

// Write pointer logic
reg [$clog2(DEPTH)-1:0] waddr_bin;
reg [$clog2(DEPTH)-1:0] wptr_bin;
reg [$clog2(DEPTH)-1:0] wptr_buff;
reg [$clog2(DEPTH)-1:0] wptr_syn;

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

always @(posedge wclk) begin
    wptr_bin <= waddr_bin;
end

always @(posedge wclk) begin
    wptr_buff <= wptr_bin;
end

// Read pointer logic
reg [$clog2(DEPTH)-1:0] raddr_bin;
reg [$clog2(DEPTH)-1:0] rptr_bin;
reg [$clog2(DEPTH)-1:0] rptr_buff;
reg [$clog2(DEPTH)-1:0] rptr_syn;

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

always @(posedge rclk) begin
    rptr_bin <= raddr_bin;
end

always @(posedge rclk) begin
    rptr_buff <= rptr_bin;
end

// Gray code conversion for write pointer
reg [$clog2(DEPTH)-1:0] wptr_gray;
always @(posedge wclk) begin
    wptr_gray <= wptr_bin ^ (wptr_bin >> 1);
end

// Gray code conversion for read pointer
reg [$clog2(DEPTH)-1:0] rptr_gray;
always @(posedge rclk) begin
    rptr_gray <= rptr_bin ^ (rptr_bin >> 1);
end

// Two-stage trigger for write pointer
always @(posedge rclk) begin
    wptr_syn <= wptr_gray;
end

// Two-stage trigger for read pointer
always @(posedge wclk) begin
    rptr_syn <= rptr_gray;
end

// Full and empty conditions
reg wfull_reg;
reg rempty_reg;
always @(*) begin
    wfull_reg = (wptr_gray == (~rptr_syn[$clog2(DEPTH)-1:1] ^ rptr_syn[0])) ? 1'b1 : 1'b0;
    rempty_reg = (wptr_syn == rptr_syn) ? 1'b1 : 1'b0;
end

assign wfull = wfull_reg;
assign rempty = rempty_reg;

// Dual-port RAM instantiation
dual_port_RAM RAM(
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr_bin[$clog2(DEPTH)-1:1]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_bin[$clog2(DEPTH)-1:1]),
    .rdata(rdata)
);

endmodule

module dual_port_RAM(
    input         wclk,        // Write clock signal
    input         wenc,        // Write enable signal
    input  [$clog2(16)-2:0] waddr, // Write address
    input  [7:0]  wdata,       // Write data
    input         rclk,        // Read clock signal
    input         renc,        // Read enable signal
    input  [$clog2(16)-2:0] raddr, // Read address
    output [7:0]  rdata        // Read data
);

reg [7:0] RAM_MEM [16-1:0];

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