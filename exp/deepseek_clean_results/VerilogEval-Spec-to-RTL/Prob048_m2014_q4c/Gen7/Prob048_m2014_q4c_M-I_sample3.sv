module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Output register
);

parameter RST_VAL = 1'b0;  // Configurable reset value

// Positive edge-triggered D flip-flop with synchronous reset
// and implicit clock enable (optimized for power)
always @(posedge clk) begin
    if (r) begin
        q <= RST_VAL;       // Synchronous reset
    end
    else if (q !== d) begin  // Only update when data changes
        q <= d;             // Data capture
    end
end

// Initialize output (simulation only)
initial begin
    q = RST_VAL;
end

endmodule