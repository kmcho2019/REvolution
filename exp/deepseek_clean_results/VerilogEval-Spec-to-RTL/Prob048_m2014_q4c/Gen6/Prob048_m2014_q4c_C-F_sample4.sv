module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Output register
);

always @(posedge clk) begin
    // Clear priority: reset overrides data input
    q <= r ? 1'b0 : d;
end

// Initialize q to 0 for simulation (synthesis ignores)
initial begin
    q = 1'b0;
end

endmodule