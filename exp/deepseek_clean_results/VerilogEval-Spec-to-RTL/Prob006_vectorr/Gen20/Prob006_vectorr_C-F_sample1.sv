/*
 * BitReverser - Optimized bit reversal module
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module BitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

always @(*) begin
    if (WIDTH == 8) begin
        // Direct assignments for optimal 8-bit implementation
        out[0] = in[7];
        out[1] = in[6];
        out[2] = in[5];
        out[3] = in[4];
        out[4] = in[3];
        out[5] = in[2];
        out[6] = in[1];
        out[7] = in[0];
    end
    else begin
        // Parameterized solution for other widths
        for (int i = 0; i < WIDTH; i = i + 1) begin
            out[i] = in[WIDTH-1-i];
        end
    end
end

endmodule

/*
 * TopModule - Wrapper maintaining original 8-bit interface
 * Uses the optimized BitReverser internally
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule