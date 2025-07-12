module TopModule (
    input  clk,    // Clock input (positive edge triggered)
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output register with explicit initialization
);

// Synchronous D Flip-Flop with active-high reset
// Uses ternary operator for concise reset logic
always @(posedge clk) begin
    q <= r ? 1'b0 : d;
end

endmodule