module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Output
);

// Positive edge-triggered D flip-flop with synchronous reset
// and implicit data enable (optimized for power)
always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Reset has priority, otherwise sample data
end

endmodule