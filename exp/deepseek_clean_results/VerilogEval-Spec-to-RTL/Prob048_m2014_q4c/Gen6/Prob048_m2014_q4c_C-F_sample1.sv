module TopModule (
    input  clk,    // Clock input
    input  d,      // Data input
    input  r,      // Synchronous reset (active high)
    output reg q   // Output register
);

always @(posedge clk) begin
    q <= r ? 1'b0 : d;  // Synchronous reset has priority
end

// Initialize q for simulation (synthesis will ignore)
initial begin
    q = 1'b0;
end

endmodule