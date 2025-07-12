module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Shared inverted inputs
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Shared OR signals
    wire or_ab  = a | b;
    wire or_nab = na | nb;

    // Product terms from the K-map solution

    // p1: ~c & ~d & (~a | ~b)
    wire p1 = nc & nd & or_nab;

    // p2: ~c & d & ~b
    wire p2 = nc & d & nb;

    // p3: c & ~d & ~a
    wire p3 = c & nd & na;

    // p4: c & d & (a | b)
    wire p4 = c & d & or_ab;

    // Final output OR of all product terms
    assign out = p1 | p2 | p3 | p4;

endmodule