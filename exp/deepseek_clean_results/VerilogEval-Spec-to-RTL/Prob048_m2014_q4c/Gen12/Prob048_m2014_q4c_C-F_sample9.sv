module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q = 1'b0  // Output register with explicit reset value
);

// Positive edge-triggered D flip-flop with synchronous reset
always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Reset has priority over data input
end

endmodule