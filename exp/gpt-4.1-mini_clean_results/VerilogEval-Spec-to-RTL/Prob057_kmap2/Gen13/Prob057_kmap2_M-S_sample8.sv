module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Complemented inputs
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Product terms
    wire term1 = nc & nd & ~(a & b);  // cd=00 and not (a & b)
    wire term2 = c & d & (a | b);     // cd=11 and (a or b)
    wire term3 = c & nd & na;          // cd=10 and a=0
    wire term4 = nc & d & nb;          // cd=01 and b=0

    assign out = term1 | term2 | term3 | term4;

endmodule