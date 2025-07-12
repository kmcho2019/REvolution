/*
 * TopModule - Optimized bit reversal with clear 8-bit mapping and parameterized fallback
 * Parameters:
 *   WIDTH = 8 (default) - Input/output bit width
 * Ports:
 *   in  - Input vector (8 bits)
 *   out - Output with reversed bit order (8 bits)
 */
module TopModule #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);

generate
    if (WIDTH == 8) begin : optimized_8bit
        // Direct, clear bit reversal mapping for optimal 8-bit case
        assign out = {in[0], in[1], in[2], in[3], 
                     in[4], in[5], in[6], in[7]};
    end
    else begin : generic_case
        // Parameterized solution for other widths
        genvar i;
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_reverse
            assign out[i] = in[WIDTH-1-i];
        end
    end
endgenerate

endmodule