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

// Dual-port RAM module
module dual_port_RAM #(
    parameter DEPTH = 16, // Configurable depth
    parameter WIDTH = 8   // Configurable width
) (
    input           wclk,    // Write clock signal
    input           wenc,    // Write enable signal
    input   [$clog2(DEPTH)-1:0] waddr, // Write address
    input   [WIDTH-1:0] wdata, // Write data
    input           rclk,    // Read clock signal
    input           renc,    // Read enable signal
    input   [$clog2(DEPTH)-1:0] raddr, // Read address
    output  logic [WIDTH-1:0] rdata  // Read data output
);

logic [WIDTH-1:0] ram[DEPTH-1:0]; // Ring buffer

assign rdata = ram[raddr];

always_ff @(posedge wclk) begin
    if (wenc) begin
        ram[waddr] <= wdata;
    end
end

endmodule

// Instantiate dual-port RAM module
dual_port_RAM #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) u_ram (
    .wclk(wclk),
    .wenc(wenc),
    .waddr(wptr_bin),
    .wdata(wdata),
    .rclk(rclk),
    .renc(renc),
    .raddr(rptr_bin),
    .rdata(rdata)
);

// Write pointer counter
logic [$clog2(DEPTH)-1:0] wptr_bin;
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_bin <= 0;
    end else if (winc) begin
        wptr_bin <= (wptr_bin + 1) % DEPTH;
    end
end

// Read pointer counter
logic [$clog2(DEPTH)-1:0] rptr_bin;
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_bin <= 0;
    end else if (rinc) begin
        rptr_bin <= (rptr_bin + 1) % DEPTH;
    end
end

// Write pointer synchronizer
logic [1:0] wptr_syn;
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr_syn <= 0;
    end else begin
        wptr_syn <= {wptr_syn[0], wptr_bin[0]};
    end
end

// Read pointer synchronizer
logic [1:0] rptr_syn;
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr_syn <= 0;
    end else begin
        rptr_syn <= {rptr_syn[0], rptr_bin[0]};
    end
end

// Gray code conversion
logic [2:0] wptr_gray, rptr_gray;
assign wptr_gray = (wptr_bin >> 1) ^ wptr_bin;
assign rptr_gray = (rptr_bin >> 1) ^ rptr_bin;

// Empty signal
assign rempty = (rptr_gray == wptr_gray);

// Full signal
assign wfull = ((wptr_gray + 1) % (DEPTH - 1) == rptr_gray);

// Write enable signal
logic wenc;
assign wenc = winc & ~wfull;

// Read enable signal
logic renc;
assign renc = rinc & ~rempty;

endmodule