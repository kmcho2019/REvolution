module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    wire a_or_b = a | b;
    wire na_or_b = na | b;
    wire a_xor_b = a ^ b;

    assign out = (nc & nd)
               | (c  & d  & a_or_b)
               | (c  & nd & na_or_b)
               | (nc & d  & a_xor_b);

endmodule