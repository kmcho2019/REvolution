/*
 * TopModule - Reverses bit order of 8-bit input
 * Implements two approaches:
 *   1. Direct concatenation (optimal for PPA)
 *   2. Hierarchical 4-bit reversal (demonstrates design partitioning)
 * Defaults to direct concatenation for best performance
 */
module TopModule (
    input [7:0] in,
    output [7:0] out
);
    // Optimal implementation - direct bit reversal
    assign out = {in[0], in[1], in[2], in[3],
                  in[4], in[5], in[6], in[7]};

    /* Alternative hierarchical implementation (uncomment to use)
    wire [3:0] upper_rev, lower_rev;
    
    assign upper_rev = {in[4], in[5], in[6], in[7]};  // Reverse upper nibble
    assign lower_rev = {in[0], in[1], in[2], in[3]};  // Reverse lower nibble
    
    assign out = {lower_rev, upper_rev};  // Combine reversed nibbles
    */
endmodule

/* Parameterized version for potential future use
module TopModule #(parameter WIDTH = 8) (
    input [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin: bit_reverse
            assign out[i] = in[WIDTH-1-i];
        end
    endgenerate
endmodule
*/