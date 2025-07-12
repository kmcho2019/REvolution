module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Compute all unique pairwise comparisons (10 comparisons total)
    wire a_eq_b = ~(a ^ b);
    wire a_eq_c = ~(a ^ c);
    wire a_eq_d = ~(a ^ d);
    wire a_eq_e = ~(a ^ e);
    wire b_eq_c = ~(b ^ c);
    wire b_eq_d = ~(b ^ d);
    wire b_eq_e = ~(b ^ e);
    wire c_eq_d = ~(c ^ d);
    wire c_eq_e = ~(c ^ e);
    wire d_eq_e = ~(d ^ e);

    // Build output vector with hardcoded 1's for self-comparisons
    // and reused values for symmetric comparisons
    assign out[24:20] = {
        1'b1,       // a == a
        a_eq_b,
        a_eq_c,
        a_eq_d,
        a_eq_e
    };

    assign out[19:15] = {
        a_eq_b,     // b == a (same as a == b)
        1'b1,       // b == b
        b_eq_c,
        b_eq_d,
        b_eq_e
    };

    assign out[14:10] = {
        a_eq_c,     // c == a (same as a == c)
        b_eq_c,     // c == b (same as b == c)
        1'b1,       // c == c
        c_eq_d,
        c_eq_e
    };

    assign out[9:5] = {
        a_eq_d,     // d == a (same as a == d)
        b_eq_d,     // d == b (same as b == d)
        c_eq_d,     // d == c (same as c == d)
        1'b1,       // d == d
        d_eq_e
    };

    assign out[4:0] = {
        a_eq_e,     // e == a (same as a == e)
        b_eq_e,     // e == b (same as b == e)
        c_eq_e,     // e == c (same as c == e)
        d_eq_e,     // e == d (same as d == e)
        1'b1        // e == e
    };

endmodule