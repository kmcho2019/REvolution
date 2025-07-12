module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Inverted inputs (shared once)
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Common OR terms reused in multiple products
    wire na_or_nb = na | nb;  // ~a | ~b
    wire a_or_b  = a  | b;   // a | b

    // Product terms reflecting K-map groups:

    // Group 1: (~c & ~d & (~a | ~b))
    wire group1 = nc & nd & na_or_nb;

    // Group 2: (~c & d & ~b)
    wire group2 = nc & d & nb;

    // Group 3: (c & ~d & ~a)
    wire group3 = c & nd & na;

    // Group 4: (c & d & (a | b))
    wire group4 = c & d & a_or_b;

    // Final output is OR of all groups
    assign out = group1 | group2 | group3 | group4;

endmodule