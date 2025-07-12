module asyn_fifo #(
    parameter DEPTH = 16, // Configurable depth
    parameter WIDTH = 8   // Configurable width
) (
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

logic [WIDTH-1:0] ram_rdata; // Read data from RAM
logic wenc, renc; // Write and read enable signals

logic [$clog2(DEPTH)-1:0] waddr_bin, raddr_bin; // Binary write and read addresses
logic [$clog2(DEPTH)-1:0] wptr, rptr; // Gray code write and read pointers
logic [$clog2(DEPTH)-1:0] wptr_syn, rptr_syn; // Synchronized write and read pointers

// Dual-port RAM module
dual_port_RAM #(.DEPTH(DEPTH), .WIDTH(WIDTH)) ram_inst (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(waddr_bin[$clog2(DEPTH)-2:0]), // Use lower bits for RAM address
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(raddr_bin[$clog2(DEPTH)-2:0]), // Use lower bits for RAM address
    .rdata(ram_rdata)
);

// Write pointer controller
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        waddr_bin <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
    end
end

// Read pointer controller
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        raddr_bin <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
    end
end

// Gray code conversion for write pointer
assign wptr = (waddr_bin >> 1) ^ waddr_bin;

// Gray code conversion for read pointer
assign rptr = (raddr_bin >> 1) ^ raddr_bin;

// Synchronize write pointer with read clock
always_ff @(posedge rclk) begin
    wptr_syn <= wptr;
end

// Synchronize read pointer with write clock
always_ff @(posedge wclk) begin
    rptr_syn <= rptr;
end

// Write enable signal
assign wenc = winc && ~wfull;

// Read enable signal
assign renc = rinc && ~rempty;

// Full signal generation
assign wfull = (wptr_syn[$clog2(DEPTH)-1] != rptr_syn[$clog2(DEPTH)-1]) && (wptr_syn[$clog2(DEPTH)-2:0] == rptr_syn[$clog2(DEPTH)-2:0]);

// Empty signal generation
assign rempty = (wptr_syn == rptr_syn);

// Output read data
assign rdata = ram_rdata;

endmodule

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16, // Configurable depth
    parameter WIDTH = 8  // Configurable width
) (
    input           wclk,    // Write clock signal
    input           wenc,    // Write enable signal
    input   [$clog2(DEPTH)-2:0] waddr, // Write address (lower bits)
    input   [WIDTH-1:0] wdata, // Write data
    input           rclk,    // Read clock signal
    input           renc,    // Read enable signal
    input   [$clog2(DEPTH)-2:0] raddr, // Read address (lower bits)
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