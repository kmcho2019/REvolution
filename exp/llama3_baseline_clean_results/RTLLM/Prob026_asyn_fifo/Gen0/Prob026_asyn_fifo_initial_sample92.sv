module asyn_fifo(
    input             wclk,      // Write clock signal
    input             rclk,      // Read clock signal
    input             wrstn,     // Write reset signal (0 for reset, 1 for reset inactive)
    input             rrstn,     // Read reset signal (0 for reset, 1 for reset inactive)
    input             winc,      // Write increment signal
    input             rinc,      // Read increment signal
    input   [7:0]     wdata,     // Write data input
    output reg        wfull,     // Write full signal
    output reg        rempty,    // Read empty signal
    output reg [7:0]  rdata      // Read data output
);

// Parameters
parameter DEPTH = 16;  // Depth of the FIFO
parameter WIDTH = 8;   // Width of the FIFO

// Calculate number of bits needed for addressing
localparam ADDR_BITS = $clog2(DEPTH);

// Define the dual-port RAM module
module dual_port_RAM(
    input             wclk,      // Write clock
    input             wenc,      // Write enable
    input   [ADDR_BITS-1:0] waddr, // Write address
    input   [WIDTH-1:0] wdata,  // Write data
    input             rclk,      // Read clock
    input             renc,      // Read enable
    input   [ADDR_BITS-1:0] raddr, // Read address
    output reg [WIDTH-1:0] rdata  // Read data
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

// Define the Gray code conversion function
function [ADDR_BITS-1:0] bin_to_gray;
    input [ADDR_BITS-1:0] bin;
    reg [ADDR_BITS-1:0] gray;

    gray = bin ^ (bin >> 1);
    bin_to_gray = gray;
endfunction

// Define the binary conversion function from Gray code
function [ADDR_BITS-1:0] gray_to_bin;
    input [ADDR_BITS-1:0] gray;
    reg [ADDR_BITS-1:0] bin;

    bin = gray ^ (gray >> 1);
    gray_to_bin = bin;
endfunction

// Instantiate the dual-port RAM
wire [WIDTH-1:0] ram_rdata;
reg [WIDTH-1:0] ram_wdata;
reg             ram_wenc;
reg             ram_renc;
reg   [ADDR_BITS-1:0] ram_waddr;
reg   [ADDR_BITS-1:0] ram_raddr;

dual_port_RAM dual_port_RAM_inst(
    .wclk(wclk),
    .wenc(ram_wenc),
    .waddr(ram_waddr),
    .wdata(ram_wdata),
    .rclk(rclk),
    .renc(ram_renc),
    .raddr(ram_raddr),
    .rdata(ram_rdata)
);

// Write and read pointers
reg [ADDR_BITS-1:0] waddr_bin;
reg [ADDR_BITS-1:0] raddr_bin;

// Gray code conversion
reg [ADDR_BITS-1:0] wptr;
reg [ADDR_BITS-1:0] rptr;

// Synchronized pointers
reg [ADDR_BITS-1:0] wptr_syn;
reg [ADDR_BITS-1:0] rptr_syn;

// Pointer buffers
reg [ADDR_BITS-1:0] wptr_buff;
reg [ADDR_BITS-1:0] rptr_buff;

// Full and empty signals
reg wfull_int;
reg rempty_int;

// Always blocks for write and read operations
always @(posedge wclk) begin
    if (~wrstn) begin
        waddr_bin <= 0;
        wptr <= 0;
    end else if (winc) begin
        waddr_bin <= waddr_bin + 1;
        wptr <= bin_to_gray(waddr_bin);
    end
end

always @(posedge rclk) begin
    if (~rrstn) begin
        raddr_bin <= 0;
        rptr <= 0;
    end else if (rinc) begin
        raddr_bin <= raddr_bin + 1;
        rptr <= bin_to_gray(raddr_bin);
    end
end

// Synchronize write pointer to read clock domain
always @(posedge rclk) begin
    wptr_buff <= wptr;
    wptr_syn <= wptr_buff;
end

// Synchronize read pointer to write clock domain
always @(posedge wclk) begin
    rptr_buff <= rptr;
    rptr_syn <= rptr_buff;
end

// Check for full and empty conditions
always @(*) begin
    wfull_int = (wptr_syn[ADDR_BITS-1] != rptr[ADDR_BITS-1]) && (wptr_syn[ADDR_BITS-2:0] == rptr[ADDR_BITS-2:0]);
    rempty_int = (wptr == rptr);
end

// Assign full and empty signals
assign wfull = wfull_int;
assign rempty = rempty_int;

// Assign read data
always @(posedge rclk) begin
    if (renc) begin
        rdata <= ram_rdata;
    end
end

// Control RAM operations
always @(*) begin
    ram_wenc = winc;
    ram_renc = rinc;
    ram_wdata = wdata;
    ram_waddr = waddr_bin[ADDR_BITS-1:0];
    ram_raddr = raddr_bin[ADDR_BITS-1:0];
end

endmodule