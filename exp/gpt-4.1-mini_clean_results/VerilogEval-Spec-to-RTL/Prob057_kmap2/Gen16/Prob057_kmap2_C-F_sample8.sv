module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Inverted inputs shared for multiple terms to minimize gate count
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Common OR terms reused in product terms:
    wire na_or_nb = na | nb;  // ~a | ~b
    wire a_or_b  = a  | b;    // a | b

    // Corresponding Karnaugh map groups implemented as product terms:
    // Group1: cells where ~c & ~d & (~a | ~b)
    //   Covers: cd=00, ab=00,01,10 -> from map: all 1s except ab=11
    wire term1 = nc & nd & na_or_nb;

    // Group2: ~c & d & ~b
    //   Covers: cd=01, ab=00,10 (map has 1s here)
    wire term2 = nc & d  & nb;

    // Group3: c & ~d & ~a
    //   Covers: cd=10, ab=00,01 (map has 1s here)
    wire term3 = c  & nd & na;

    // Group4: c & d & (a | b)
    //   Covers: cd=11, ab=01,10,11 (map has 1s here)
    wire term4 = c  & d  & a_or_b;

    // Final output is OR of all groups (sum of products form)
    assign out = term1 | term2 | term3 | term4;

endmodule