module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Shared inverted signals
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Shared OR terms
    wire a_or_b  = a  | b;
    wire na_or_nb = na | nb;

    // Minimal product terms from K-map groups
    wire term1 = nc & nd & na_or_nb;  // ~c & ~d & (~a | ~b)
    wire term2 = nc & d  & nb;         // ~c & d  & ~b
    wire term3 = c  & nd & na;         // c  & ~d & ~a
    wire term4 = c  & d  & a_or_b;     // c  & d  & (a | b)

    // Output is OR of all product terms
    assign out = term1 | term2 | term3 | term4;

endmodule