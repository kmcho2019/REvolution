/*
 * OptimizedBitReverser - Parameterized bit reversal with optimal implementation
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width (must be > 0)
 * Features:
 *   - Flat structure for optimal timing
 *   - Pure combinational logic
 *   - Parameter validation
 *   - Optimized for 8-bit case while maintaining general functionality
 */
module OptimizedBitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

    // Validate parameter
    initial begin
        if (WIDTH <= 0) begin
            $error("BitReverser: WIDTH must be positive (given %0d)", WIDTH);
        end
    end

    // Flat generate implementation for optimal timing
    genvar i;
    for (i = 0; i < WIDTH; i = i + 1) begin : BIT_REV
        assign out[i] = in[WIDTH-1-i];
    end

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Uses the optimized BitReverser internally
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate with optimized implementation
    OptimizedBitReverser #(
        .WIDTH(8)
    ) reverser (
        .in(in),
        .out(out)
    );

endmodule