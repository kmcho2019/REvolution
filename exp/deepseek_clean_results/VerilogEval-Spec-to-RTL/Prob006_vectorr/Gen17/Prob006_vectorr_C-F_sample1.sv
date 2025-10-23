/*
 * OptimizedBitReverser - Best-of-both-worlds bit reversal module
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector
 *   out - Output with reversed bit order
 */
module OptimizedBitReverser #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output reg [WIDTH-1:0] out
);

generate
    if (WIDTH == 8) begin : optimized_8bit
        // Power-optimized combinational block with explicit mapping
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
    end
    else begin : generic_case
        // Parameterized solution for other widths
        always @(*) begin
            for (int i = 0; i < WIDTH; i = i + 1) begin
                out[i] = in[WIDTH-1-i];
            end
        end
    end
endgenerate

endmodule

// TopModule maintains original 8-bit interface
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    OptimizedBitReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule