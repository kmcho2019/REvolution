/**
 * Optimized 8-bit Register with Synchronous Reset
 * 
 * Improvements:
 * - Removed unused all_ones detection
 * - Fixed 8-bit width (no parameter overhead)
 * - Clean synchronous reset implementation
 * - Minimal logic for best PPA
 */

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;          // Synchronous reset
        end else begin
            q <= d;             // Normal data input
        end
    end

endmodule