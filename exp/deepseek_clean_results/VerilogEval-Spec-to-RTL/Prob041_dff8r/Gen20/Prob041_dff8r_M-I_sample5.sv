/**
 * Optimized 8-bit DFF Array with Synchronous Reset
 * 
 * Features:
 * - 8 positive edge-triggered D flip-flops
 * - Synchronous active-high reset
 * - Simple array implementation for best PPA
 */

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    always @(posedge clk) begin
        if (reset) q <= 8'b0;
        else q <= d;
    end

endmodule