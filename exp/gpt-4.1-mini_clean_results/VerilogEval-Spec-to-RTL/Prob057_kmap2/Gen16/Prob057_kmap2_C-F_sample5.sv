module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Invert inputs once for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Shared common terms from inputs, reused in multiple product terms
    wire na_or_nb = na | nb;  // ~a + ~b
    wire a_or_b  = a  | b;    // a + b

    // Direct combinational logic assignment using minimal product terms
    assign out = (nc & nd & na_or_nb)       // group covering cd=00 with ~a+~b
               | (nc & d  & nb)             // group covering cd=01 with ~b
               | (c  & nd & na)             // group covering cd=10 with ~a
               | (c  & d  & a_or_b);        // group covering cd=11 with a+b

endmodule