/**
 * Optimized 8-bit Register with Synchronous Reset
 * Features:
 * - Fixed 8-bit width as specified
 * - Synchronous active-high reset (sets output to 0)
 * - Single always block for optimal PPA
 * - Clean, minimal implementation
 */
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 8'b0;      // Synchronous reset to 0
    else
        q <= d;         // Normal operation
end

endmodule