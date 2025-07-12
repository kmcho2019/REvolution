/*
 * Optimized BitReverser - Fixed 8-bit implementation with power optimization
 * Uses direct concatenation for clearer bit reversal and reduced switching
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module BitReverser (
    input [7:0] in,
    output [7:0] out
);

    // Direct bit reversal with explicit ordering
    assign out = {in[0], in[1], in[2], in[3], 
                 in[4], in[5], in[6], in[7]};

    /* Parameterized version (commented out for fixed-width optimization)
    module BitReverser #(parameter WIDTH=8) (
        input [WIDTH-1:0] in,
        output [WIDTH-1:0] out
    );
        assign out = {in[0], in[1], in[2], in[3], 
                     in[4], in[5], in[6], in[7]};
    endmodule
    */

endmodule

/*
 * TopModule - Wrapper maintaining original interface
 * Ports:
 *   in  - 8-bit input
 *   out - 8-bit reversed output
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);

    BitReverser reverser (
        .in(in),
        .out(out)
    );

endmodule