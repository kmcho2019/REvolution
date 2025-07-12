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

    // Shared common terms
    wire nand_ab = ~(a & b);   // ~ (a & b)
    wire or_ab  = a | b;       // a | b

    // Product terms covering K-map groups
    wire term1 = nc & nd & nand_ab;  // cd=00 and not (a & b)
    wire term2 = c  & d  & or_ab;    // cd=11 and (a or b)
    wire term3 = c  & nd & na;       // cd=10 and a=0
    wire term4 = nc & d  & nb;       // cd=01 and b=0

    // Final output
    assign out = term1 | term2 | term3 | term4;

endmodule