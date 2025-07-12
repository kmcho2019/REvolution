/*
 * Synchronous D Flip-Flop with Active High Reset
 * 
 * Parameters:
 *   RESET_VAL - Value to output when reset is active (default 0)
 * 
 * Ports:
 *   clk - Clock input
 *   r   - Active high synchronous reset
 *   d   - Data input
 *   q   - Data output (registered)
 */
module TopModule #(
    parameter RESET_VAL = 1'b0
)(
    input  clk,
    input  r,    // Synchronous reset (active high)
    input  d,    // Data input
    output reg q // Registered output
);

// Positive edge-triggered DFF with synchronous reset
always @(posedge clk) begin
    if (r) begin
        q <= RESET_VAL;  // Synchronous reset to specified value
    end
    else begin
        q <= d;          // Normal data capture
    end
end

endmodule