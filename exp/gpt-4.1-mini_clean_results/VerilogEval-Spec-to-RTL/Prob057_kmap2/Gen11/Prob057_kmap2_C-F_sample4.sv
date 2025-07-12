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

    // Shared common OR terms to reduce logic duplication
    wire na_or_nb = na | nb;  // ~a | ~b
    wire a_or_b  = a  | b;   // a | b

    // Define intermediate product terms that correspond directly to K-map groups
    wire term1 = nc & nd & na_or_nb;  // Group for c=0,d=0 and (a,b)=00,01,10 with output 1
    wire term2 = nc & d  & nb;         // Group for c=0,d=1,b=0 (a,b) cases 00 and 10
    wire term3 = c  & nd & na;         // Group for c=1,d=0,a=0 (a,b) cases 00 and 01
    wire term4 = c  & d  & a_or_b;     // Group for c=1,d=1,a or b =1 (covers all 11 column ones)

    // Output is OR of all groups
    assign out = term1 | term2 | term3 | term4;

endmodule