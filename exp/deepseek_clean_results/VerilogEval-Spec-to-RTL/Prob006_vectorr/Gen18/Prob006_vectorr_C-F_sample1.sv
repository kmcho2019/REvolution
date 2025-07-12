/*
 * OptimizedBitReverser - Superior fused implementation combining best of both examples
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector to reverse
 *   out - Output with reversed bit order
 */
module OptimizedBitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

    // Combinational always block for power efficiency
    always @(*) begin
        out[0] = in[7];
        out[1] = in[6];
        out[2] = in[5];
        out[3] = in[4];
        out[4] = in[3];
        out[5] = in[2];
        out[6] = in[1];
        out[7] = in[0];
    end

endmodule

/*
 * TopModule - Clean wrapper maintaining original 8-bit interface
 * Provides consistent interface while allowing internal optimization
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    // Instantiate optimized reverser with default width
    OptimizedBitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule