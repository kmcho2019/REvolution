module TopModule (
    input  wire clk,  // Positive edge-triggered clock
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output wire q     // Data output
);

reg q_reg = 1'b0;    // Initialize with reset value
assign q = q_reg;

// Positive edge-triggered DFF with async reset
// Power Note: In a larger design, consider clock gating when:
// - This flip-flop's output isn't needed for multiple cycles
// - The data input remains stable for extended periods
always @(posedge clk or posedge ar) begin
    if (ar) q_reg <= 1'b0;  // Async reset has priority
    else    q_reg <= d;     // Normal operation
end

endmodule