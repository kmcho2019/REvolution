/*
 * OptimizedBitReverser - Refactored version using continuous assignments
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
    output [WIDTH-1:0] out
);

generate
    if (WIDTH == 8) begin : optimized_8bit
        // Direct continuous assignments for 8-bit case
        assign out[0] = in[7];
        assign out[1] = in[6];
        assign out[2] = in[5];
        assign out[3] = in[4];
        assign out[4] = in[3];
        assign out[5] = in[2];
        assign out[6] = in[1];
        assign out[7] = in[0];
    end
    else begin : generic_case
        // Parameterized solution using generate-for with assigns
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse
            assign out[i] = in[WIDTH-1-i];
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