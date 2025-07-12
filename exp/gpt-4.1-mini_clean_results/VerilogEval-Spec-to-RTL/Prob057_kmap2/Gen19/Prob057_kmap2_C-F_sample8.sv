module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Complemented inputs (inverted once for reuse)
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Product terms from K-map minimal SOP without extra intermediates:
    // term1: ~c & ~d & ~(a & b)  = nc & nd & (~(a & b))
    // term2: c & d & (a | b)     = c & d & (a | b)
    // term3: c & ~d & ~a         = c & nd & na
    // term4: ~c & d & ~b         = nc & d & nb

    // Directly implement product terms:
    wire term1 = nc & nd & ~(a & b);
    wire term2 = c & d & (a | b);
    wire term3 = c & nd & na;
    wire term4 = nc & d & nb;

    assign out = term1 | term2 | term3 | term4;

endmodule