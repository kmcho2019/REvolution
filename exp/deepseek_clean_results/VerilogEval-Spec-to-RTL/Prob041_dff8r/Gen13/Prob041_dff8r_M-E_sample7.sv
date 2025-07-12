/**
 * Compact 8-bit Register with Synchronous Reset and All-Ones Detection
 * 
 * Features:
 * - Single always block implementation
 * - Built-in all-ones detection (optional monitoring)
 * - No redundant clock enable logic
 * - Direct synchronous reset implementation
 * - Clean parameterized design
 */

module TopModule #(
    parameter WIDTH = 8
) (
    input clk,
    input reset,
    input [WIDTH-1:0] d,
    output reg [WIDTH-1:0] q,
    output all_ones      // Optional: indicates when all bits are 1
);

    // All ones detection logic
    assign all_ones = &q;

    // Compact register implementation
    always @(posedge clk) begin
        if (reset) begin
            q <= {WIDTH{1'b0}};  // Direct synchronous reset
        end else begin
            q <= d;               // Normal data input
        end
    end

    // Parameter validation (compile-time only)
    initial begin
        if (WIDTH < 1) $error("WIDTH must be at least 1");
    end

endmodule