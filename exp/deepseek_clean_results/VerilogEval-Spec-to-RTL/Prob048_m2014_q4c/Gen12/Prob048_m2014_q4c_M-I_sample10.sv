module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Output register
);

// Synchronous D flip-flop with active-high reset
// Reset has priority and occurs on rising clock edge
always @(posedge clk) begin
    q <= r ? 1'b0 : d;
end

endmodule