/*
 * Synchronous D Flip-Flop with Active High Reset
 * 
 * Features:
 * - Positive edge-triggered data capture
 * - Synchronous active-high reset
 * - Configurable reset value
 * - Fully synthesizable and technology-portable
 *
 * Parameters:
 *   RESET_VAL - Output value during reset (default 0)
 *               Note: Changing this may affect PPA in some technologies
 *
 * Ports:
 *   clk - Clock input (all operations synchronized to rising edge)
 *   r   - Synchronous reset (active high, sampled at clock edge)
 *   d   - Data input (sampled at clock edge when not in reset)
 *   q   - Registered output (updated only at clock edges)
 *
 * Usage Notes:
 * - For asynchronous reset requirements, add external synchronization
 * - Reset signal should meet setup/hold times relative to clk
 */
module TopModule #(
    parameter RESET_VAL = 1'b0
)(
    input  clk,
    input  r,
    input  d,
    output reg q
);

always @(posedge clk) begin
    q <= r ? RESET_VAL : d;  // Synchronous reset has priority
end

endmodule