module asyn_fifo (
    input           wclk,    // Write clock signal
    input           rclk,    // Read clock signal
    input           wrstn,   // Write reset signal (active low)
    input           rrstn,   // Read reset signal (active low)
    input           winc,    // Write increment signal
    input           rinc,    // Read increment signal
    input   [WIDTH-1:0] wdata, // Write data input
    output  logic           wfull,  // Write full signal
    output  logic           rempty, // Read empty signal
    output  logic [WIDTH-1:0] rdata  // Read data output
);

parameter DEPTH = 16; // Configurable depth
parameter WIDTH = 8;  // Configurable width

logic [WIDTH-1:0] ram_rdata; // Read data from RAM
logic [WIDTH-1:0] ram_wdata; // Write data to RAM

logic wenc, renc; // Write and read enable signals

logic [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin; // Binary write and read addresses
logic [$clog2(DEPTH)-1:0] wptr_buff, rptr_buff; // Buffered write and read pointers

logic [$clog2(DEPTH)-1:0] wptr, rptr; // Gray code write and read pointers
logic [$clog2(DEPTH)-1:0] rptr_syn; // Synchronized read pointer

// Dual-port RAM module
dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin),
    .rdata(ram_rdata)
);

// Write pointer controller
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr_buff <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr_buff <= wptr_buff + 1;
    end
end

// Read pointer controller
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr_buff <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr_buff <= rptr_buff + 1;
    end
end

// Gray code conversion for write pointer
always_comb begin
    wptr = (wptr_buff >> 1) ^ wptr_buff;
end

// Gray code conversion for read pointer
always_comb begin
    rptr = (rptr_buff >> 1) ^ rptr_buff;
end

// Synchronize read pointer with write clock
always_ff @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Write enable signal
always_comb begin
    wenc = winc && ~wfull;
end

// Read enable signal
always_comb begin
    renc = rinc && ~rempty;
end

// Full signal
always_comb begin
    wfull = (wptr == (~rptr_syn[$clog2(DEPTH)-1] & rptr_syn[$clog2(DEPTH)-2:0]));
end

// Empty signal
always_comb begin
    rempty = (rptr == wptr);
end

// Output read data
always_comb begin
    rdata = ram_rdata;
end

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16, // Configurable depth
    parameter WIDTH = 8  // Configurable width
) (
    input           wclk,    // Write clock signal
    input           wenc,    // Write enable signal
    input   [$clog2(DEPTH)-1:0] waddr, // Write address
    input   [WIDTH-1:0] wdata, // Write data
    input           rclk,    // Read clock signal
    input           renc,    // Read enable signal
    input   [$clog2(DEPTH)-1:0] raddr, // Read address
    output  logic [WIDTH-1:0] rdata  // Read data
);

logic [WIDTH-1:0] ram_mem [DEPTH-1:0]; // RAM memory

// Write operation
always_ff @(posedge wclk) begin
    if (wenc) begin
        ram_mem[waddr] <= wdata;
    end
end

// Read operation
always_ff @(posedge rclk) begin
    if (renc) begin
        rdata <= ram_mem[raddr];
    end
end

endmodule