module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Unique pairwise comparisons (10 total)
    wire a_eq_b = a ~^ b;
    wire a_eq_c = a ~^ c;
    wire a_eq_d = a ~^ d;
    wire a_eq_e = a ~^ e;
    wire b_eq_c = b ~^ c;
    wire b_eq_d = b ~^ d;
    wire b_eq_e = b ~^ e;
    wire c_eq_d = c ~^ d;
    wire c_eq_e = c ~^ e;
    wire d_eq_e = d ~^ e;

    // Self-comparisons (always 1)
    localparam SELF_EQ = 1'b1;

    // Organized output assignment using concatenation
    assign out = {
        // a comparisons (5)
        SELF_EQ,    // a == a
        a_eq_b,     // a == b
        a_eq_c,     // a == c
        a_eq_d,     // a == d
        a_eq_e,     // a == e
        
        // b comparisons (5)
        a_eq_b,     // b == a (reuse)
        SELF_EQ,    // b == b
        b_eq_c,     // b == c
        b_eq_d,     // b == d
        b_eq_e,     // b == e
        
        // c comparisons (5)
        a_eq_c,     // c == a (reuse)
        b_eq_c,     // c == b (reuse)
        SELF_EQ,    // c == c
        c_eq_d,     // c == d
        c_eq_e,     // c == e
        
        // d comparisons (5)
        a_eq_d,     // d == a (reuse)
        b_eq_d,     // d == b (reuse)
        c_eq_d,     // d == c (reuse)
        SELF_EQ,    // d == d
        d_eq_e,     // d == e
        
        // e comparisons (5)
        a_eq_e,     // e == a (reuse)
        b_eq_e,     // e == b (reuse)
        c_eq_e,     // e == c (reuse)
        d_eq_e,     // e == d (reuse)
        SELF_EQ     // e == e
    };

endmodule