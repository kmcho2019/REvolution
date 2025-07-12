/*
 * BitReverser - Optimized parameterized bit reversal module
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width (must be > 0)
 * Ports:
 *   in  - Input vector to reverse
 *   out - Output with reversed bit order
 */
module BitReverser #(
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

    // Generate loop with explicit bit reversal mapping
    generate
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : BIT_REV
            // Reverse mapping: out[0] = in[WIDTH-1], out[1] = in[WIDTH-2], etc.
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Provides clean interface while allowing internal parameterization
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate parameterized reverser with default width
    BitReverser #(
        .WIDTH(8)
    ) reverser (
        .in(in),
        .out(out)
    );

endmodule