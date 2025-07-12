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

    // Common OR terms
    wire na_or_nb = na | nb; // ~a | ~b
    wire a_or_b  = a  | b;   // a | b

    // Product terms from K-map groups
    wire term1 = nc & nd & na_or_nb;  // cd=00 and ab=00,01,10
    wire term2 = nc & d  & nb;         // cd=01 and b=0
    wire term3 = c  & nd & na;         // cd=10 and a=0
    wire term4 = c  & d  & a_or_b;     // cd=11 and a or b=1

    assign out = term1 | term2 | term3 | term4;

endmodule