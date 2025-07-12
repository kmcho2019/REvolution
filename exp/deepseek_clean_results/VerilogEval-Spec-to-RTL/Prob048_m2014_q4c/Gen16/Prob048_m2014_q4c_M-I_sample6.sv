module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Registered output
);

// Synchronous reset D flip-flop
always @(posedge clk) begin
    if (r) q <= 1'b0;  // Reset has priority
    else   q <= d;     // Normal operation
end

endmodule