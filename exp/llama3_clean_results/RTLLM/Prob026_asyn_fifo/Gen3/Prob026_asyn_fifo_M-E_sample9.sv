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

logic [WIDTH-1:0] ram[DEPTH-1:0]; // Ring buffer

logic [$clog2(DEPTH)-1:0] wptr, rptr; // Write and read pointers

// Write pointer counter
always_ff @(posedge wclk or negedge wrstn) begin
    if (~wrstn) begin
        wptr <= 0;
    end else if (winc) begin
        wptr <= (wptr + 1) % DEPTH;
    end
end

// Read pointer counter
always_ff @(posedge rclk or negedge rrstn) begin
    if (~rrstn) begin
        rptr <= 0;
    end else if (rinc) begin
        rptr <= (rptr + 1) % DEPTH;
    end
end

// Write operation
always_ff @(posedge wclk) begin
    if (winc) begin
        ram[wptr] <= wdata;
    end
end

// Read operation
always_ff @(posedge rclk) begin
    if (rinc) begin
        rdata <= ram[rptr];
    end
end

// Empty signal
assign rempty = (rptr == wptr);

// Full signal
assign wfull = ((wptr + 1) % DEPTH == rptr);

endmodule