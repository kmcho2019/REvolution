/*
 * BitReverser - Optimized bit reversal module combining best of both approaches
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

generate
    if (WIDTH == 8) begin : optimized_8bit
        // Explicit bit reversal in combinational always block
        always @(*) begin
            out = {in[0], in[1], in[2], in[3], 
                   in[4], in[5], in[6], in[7]};
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

    BitReverser #(8) reverser (
        .in(in),
        .out(out)
    );

endmodule