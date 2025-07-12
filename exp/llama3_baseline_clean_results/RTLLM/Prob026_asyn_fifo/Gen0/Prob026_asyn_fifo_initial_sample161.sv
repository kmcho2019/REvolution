// Define parameters for the FIFO
parameter WIDTH = 8;
parameter DEPTH = 16;

// Define module for the asynchronous FIFO
module asyn_fifo(
    // Input ports
    input  wclk,      // Write clock signal
    input  rclk,      // Read clock signal
    input  wrstn,     // Write reset signal
    input  rrstn,     // Read reset signal
    input  winc,      // Write increment signal
    input  rinc,      // Read increment signal
    input  [WIDTH-1:0] wdata,  // Write data input

    // Output ports
    output reg  wfull,     // Write full signal
    output reg  rempty,    // Read empty signal
    output reg [WIDTH-1:0] rdata  // Read data output
);

// Define internal signals
reg [WIDTH-1:0] waddr_bin;  // Binary write address
reg [WIDTH-1:0] raddr_bin;  // Binary read address
reg [$clog2(DEPTH)-1:0] wptr;  // Gray code write pointer
reg [$clog2(DEPTH)-1:0] rptr;  // Gray code read pointer
reg [$clog2(DEPTH)-1:0] wptr_buff;  // Buffer for write pointer
reg [$clog2(DEPTH)-1:0] rptr_buff;  // Buffer for read pointer
reg [$clog2(DEPTH)-1:0] wptr_syn;  // Synchronized write pointer
reg [$clog2(DEPTH)-1:0] rptr_syn;  // Synchronized read pointer
reg wenc;  // Write enable signal
reg renc;  // Read enable signal

// Instantiate the dual-port RAM
dual_port_RAM u_ram(
    .wclk(wclk),      // Write clock signal
    .wenc(wenc),      // Write enable signal
    .waddr(waddr_bin),  // Write address
    .wdata(wdata),    // Write data
    .rclk(rclk),      // Read clock signal
    .renc(renc),      // Read enable signal
    .raddr(raddr_bin),  // Read address
    .rdata(rdata)     // Read data
);

// Generate write pointer (Gray code)
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Generate write pointer (Gray code)
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr <= 0;
    end else begin
        wptr <= (waddr_bin >> 1) ^ waddr_bin;
    end
end

// Buffer write pointer
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wptr_buff <= 0;
    end else begin
        wptr_buff <= wptr;
    end
end

// Synchronize write pointer (two-stage trigger)
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        wptr_syn <= 0;
    end else begin
        wptr_syn <= wptr_buff;
    end
end

// Generate read pointer (Gray code)
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Generate read pointer (Gray code)
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr <= 0;
    end else begin
        rptr <= (raddr_bin >> 1) ^ raddr_bin;
    end
end

// Buffer read pointer
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        rptr_buff <= 0;
    end else begin
        rptr_buff <= rptr;
    end
end

// Synchronize read pointer (two-stage trigger)
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        rptr_syn <= 0;
    end else begin
        rptr_syn <= rptr_buff;
    end
end

// Generate empty signal
always @(*) begin
    if (rptr_syn == wptr_syn) begin
        rempty <= 1'b1;
    end else begin
        rempty <= 1'b0;
    end
end

// Generate full signal
always @(*) begin
    if (wptr_syn == (~rptr_syn[$clog2(DEPTH)-1] & rptr_syn) | ((wptr_syn[$clog2(DEPTH)-2]) & rptr_syn)) begin
        wfull <= 1'b1;
    end else begin
        wfull <= 1'b0;
    end
end

// Control write enable signal
always @(posedge wclk or negedge wrstn) begin
    if (!wrstn) begin
        wenc <= 1'b0;
    end else if (winc && !wfull) begin
        wenc <= 1'b1;
    end else begin
        wenc <= 1'b0;
    end
end

// Control read enable signal
always @(posedge rclk or negedge rrstn) begin
    if (!rrstn) begin
        renc <= 1'b0;
    end else if (rinc && !rempty) begin
        renc <= 1'b1;
    end else begin
        renc <= 1'b0;
    end
end

endmodule

// Dual-port RAM module
module dual_port_RAM(
    input  wclk,      // Write clock signal
    input  wenc,      // Write enable signal
    input [$clog2(DEPTH)-1:0] waddr,  // Write address
    input [WIDTH-1:0] wdata,    // Write data
    input  rclk,      // Read clock signal
    input  renc,      // Read enable signal
    input [$clog2(DEPTH)-1:0] raddr,  // Read address
    output reg [WIDTH-1:0] rdata  // Read data
);

// Define RAM memory
reg [WIDTH-1:0] RAM_MEM [0:DEPTH-1];

// Write operation
always @(posedge wclk) begin
    if (wenc) begin
        RAM_MEM[waddr] <= wdata;
    end
end

// Read operation
always @(posedge rclk) begin
    if (renc) begin
        rdata <= RAM_MEM[raddr];
    end
end

endmodule