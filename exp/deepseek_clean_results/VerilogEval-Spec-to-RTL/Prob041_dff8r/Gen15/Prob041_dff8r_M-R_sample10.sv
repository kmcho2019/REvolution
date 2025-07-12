/**
 * TopModule - 8-bit Register with Synchronous Reset
 * 
 * Simplified version with:
 * - Parameterized width (default 8 bits)
 * - Positive edge-triggered flip-flops
 * - Synchronous active-high reset
 * - Direct always block implementation
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q
);

    // Parameter validation
    initial begin
        if (WIDTH < 1) $error("WIDTH must be at least 1");
    end

    // Direct flip-flop implementation
    always @(posedge clk) begin
        if (reset) begin
            q <= {WIDTH{1'b0}};  // Synchronous reset to zero
        end else begin
            q <= d;               // Normal operation
        end
    end

endmodule