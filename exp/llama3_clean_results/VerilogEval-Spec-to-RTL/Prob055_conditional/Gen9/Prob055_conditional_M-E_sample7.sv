module TopModule(
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] min
);

    // First level of comparisons
    wire [7:0] min_ab;
    wire [7:0] min_cd;

    assign min_ab = a < b? a : b;
    assign min_cd = c < d? c : d;

    // Second level of comparison to find the overall minimum
    assign min = min_ab < min_cd? min_ab : min_cd;

    // Alternatively, a more explicit tree structure could be represented
    // using additional wires for each comparison level, but this would
    // essentially replicate the same logic in a more verbose manner.

endmodule