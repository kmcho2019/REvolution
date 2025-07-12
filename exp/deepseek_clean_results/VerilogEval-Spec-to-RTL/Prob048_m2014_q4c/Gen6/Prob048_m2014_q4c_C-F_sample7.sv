/*
 * High-Efficiency D Flip-Flop with Synchronous Reset
 * 
 * Features:
 * - Explicit mux-based reset path for optimal synthesis
 * - Parameterized reset value
 * - Clean, documented interface
 * - Maintains optimal PPA characteristics
 *
 * Parameters:
 *   RESET_VAL - Value to output when reset is active (default 0)
 * 
 * Ports:
 *   clk - Clock input (posedge triggered)
 *   r   - Active high synchronous reset
 *   d   - Data input
 *   q   - Registered data output
 */
module TopModule #(
    parameter RESET_VAL = 1'b0
)(
    input  clk,
    input  r,
    input  d,
    output reg q
);

// Explicit reset mux for clear synthesis path
wire next_q = r ? RESET_VAL : d;

// Positive edge-triggered DFF
always @(posedge clk) begin
    q <= next_q;  // Non-blocking assignment for proper sequential behavior
end

endmodule