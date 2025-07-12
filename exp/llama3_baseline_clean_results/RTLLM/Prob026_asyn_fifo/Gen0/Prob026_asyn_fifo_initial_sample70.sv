module asyn_fifo (
    input wclk,  // Write clock signal
    input rclk,  // Read clock signal
    input wrstn,  // Write reset signal
    input rrstn,  // Read reset signal
    input winc,  // Write increment signal
    input rinc,  // Read increment signal
    input [WIDTH-1:0] wdata,  // Write data input
    output wfull,  // Write full signal
    output rempty,  // Read empty signal
    output [WIDTH-1:0] rdata  // Read data output
);

parameter WIDTH = 8;
parameter DEPTH = 16;

// Dual-port RAM module
module dual_port_RAM (
    input wclk,  // Write clock signal
    input wenc,  // Write enable signal
    input [$clog2(DEPTH)-1:0] waddr,  // Write address
    input [WIDTH-1:0] wdata,  // Write data input
    input rclk,  // Read clock signal
    input renc,  // Read enable signal
    input [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata  // Read data output
);

reg [WIDTH-1:0] RAM_MEM [DEPTH-1:0];  // RAM memory

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

reg [WIDTH-1:0] rdata_reg;  // Register to hold read data
reg wfull_reg;  // Register to hold write full signal
reg rempty_reg;  // Register to hold read empty signal

// Instantiate dual-port RAM module
dual_port_RAM RAM (
   .wclk(wclk),
   .wenc(winc),
   .waddr(waddr_bin),
   .wdata(wdata),
   .rclk(rclk),
   .renc(rinc),
   .raddr(raddr_bin),
   .rdata(rdata_reg)
);

reg [$clog2(DEPTH)-1:0] waddr_bin;  // Binary write address
reg [$clog2(DEPTH)-1:0] raddr_bin;  // Binary read address
reg [$clog2(DEPTH)-1:0] wptr;  // Write pointer
reg [$clog2(DEPTH)-1:0] rptr;  // Read pointer
reg [$clog2(DEPTH)-1:0] wptr_buff;  // Write pointer buffer
reg [$clog2(DEPTH)-1:0] rptr_buff;  // Read pointer buffer
reg [$clog2(DEPTH)-1:0] wptr_syn;  // Synchronized write pointer
reg [$clog2(DEPTH)-1:0] rptr_syn;  // Synchronized read pointer

// Write controller
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= wptr + 1;
    end
end

// Read controller
always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= rptr + 1;
    end
end

// Gray code conversion for write pointer
always @(posedge wclk) begin
    wptr_buff <= wptr;
    wptr_syn <= wptr_buff;
end

// Gray code conversion for read pointer
always @(posedge rclk) begin
    rptr_buff <= rptr;
    rptr_syn <= rptr_buff;
end

// Full and empty signals
always @(posedge wclk) begin
    wfull_reg <= (wptr_syn[$clog2(DEPTH)-1]!= rptr_syn[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);
end

always @(posedge rclk) begin
    rempty_reg <= (rptr_syn == wptr_syn);
end

assign wfull = wfull_reg;  // Assign write full signal
assign rempty = rempty_reg;  // Assign read empty signal
assign rdata = rdata_reg;  // Assign read data output

endmodule