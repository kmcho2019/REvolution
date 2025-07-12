module TopModule (
    input  a, b, c, d, e,
    output [24:0] out
);

    // Precompute all unique pairwise comparisons (10 total)
    wire a_b = a ~^ b;
    wire a_c = a ~^ c;
    wire a_d = a ~^ d;
    wire a_e = a ~^ e;
    wire b_c = b ~^ c;
    wire b_d = b ~^ d;
    wire b_e = b ~^ e;
    wire c_d = c ~^ d;
    wire c_e = c ~^ e;
    wire d_e = d ~^ e;

    assign out = {
        // First row (a comparisons)
        1'b1,    // a~a
        a_b, a_c, a_d, a_e,
        // Second row (b comparisons)
        a_b,     // b~a (same as a~b)
        1'b1,    // b~b
        b_c, b_d, b_e,
        // Third row (c comparisons)
        a_c, b_c, // c~a, c~b
        1'b1,    // c~c
        c_d, c_e,
        // Fourth row (d comparisons)
        a_d, b_d, c_d, // d~a, d~b, d~c
        1'b1,    // d~d
        d_e,
        // Fifth row (e comparisons)
        a_e, b_e, c_e, d_e, // e~a, e~b, e~c, e~d
        1'b1     // e~e
    };

endmodule