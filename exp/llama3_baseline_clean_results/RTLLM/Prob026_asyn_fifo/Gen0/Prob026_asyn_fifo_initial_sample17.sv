module asyn_fifo(
    input wclk, // Write clock signal
    input rclk, // Read clock signal
    input wrstn, // Write reset signal
    input rrstn, // Read reset signal
    input winc, // Write increment signal
    input rinc, // Read increment signal
    input [WIDTH-1:0] wdata, // Write data input
    output wfull, // Write full signal
    output rempty, // Read empty signal
    output [WIDTH-1:0] rdata // Read data output
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1]; // Dual-port RAM memory
reg [WIDTH-1:0] rdata_reg; // Register to hold the read data

// Write pointer
reg [$clog2(DEPTH)-1:0] waddr_bin; // Binary write pointer
reg [$clog2(DEPTH)-1:0] wptr; // Gray code write pointer
reg [$clog2(DEPTH)-1:0] wptr_buff; // Buffer to hold the previous write pointer value

// Read pointer
reg [$clog2(DEPTH)-1:0] raddr_bin; // Binary read pointer
reg [$clog2(DEPTH)-1:0] rptr; // Gray code read pointer
reg [$clog2(DEPTH)-1:0] rptr_syn; // Synchronized Gray code read pointer
reg [$clog2(DEPTH)-1:0] rptr_buff; // Buffer to hold the previous read pointer value

always @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin // Reset the write pointer
        waddr_bin <= 0;
        wptr <= 0;
        wptr_buff <= 0;
    end else if (winc) begin // Increment the write pointer
        waddr_bin <= waddr_bin + 1;
        wptr <= waddr_bin ^ (waddr_bin >> 1); // Convert to Gray code
        wptr_buff <= wptr;
    end
end

always @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin // Reset the read pointer
        raddr_bin <= 0;
        rptr <= 0;
        rptr_syn <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin // Increment the read pointer
        raddr_bin <= raddr_bin + 1;
        rptr <= raddr_bin ^ (raddr_bin >> 1); // Convert to Gray code
        rptr_syn <= rptr_buff; // Synchronize the read pointer
        rptr_buff <= rptr;
    end
end

assign wfull = (wptr == {~rptr_syn[$clog2(DEPTH)-1], rptr_syn[$clog2(DEPTH)-2:0]}); // FIFO is full
assign rempty = (rptr_syn == wptr); // FIFO is empty

// Dual-port RAM instantiation
dual_port_RAM ram(
    .wclk(wclk),
    .wenc(winc),
    .waddr(wptr[0:$clog2(DEPTH)-2]),
    .wdata(wdata),
    .rclk(rclk),
    .renc(rinc),
    .raddr(rptr_syn[0:$clog2(DEPTH)-2]),
    .rdata(rdata_reg)
);

assign rdata = rdata_reg;

endmodule

module dual_port_RAM(
    input wclk, // Write clock signal
    input wenc, // Write enable signal
    input [$clog2(DEPTH)-2:0] waddr, // Write address
    input [WIDTH-1:0] wdata, // Write data
    input rclk, // Read clock signal
    input renc, // Read enable signal
    input [$clog2(DEPTH)-2:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata // Read data
);

parameter WIDTH = 8;
parameter DEPTH = 16;

reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1]; // Dual-port RAM memory

always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata; // Write data into RAM
    end
end

always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr]; // Read data from RAM
    end
end

endmodule