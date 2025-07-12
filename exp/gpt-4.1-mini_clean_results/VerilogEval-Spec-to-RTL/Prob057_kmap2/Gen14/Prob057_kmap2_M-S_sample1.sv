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

    assign out =
          (nc & nd & na)
        | (nc & nd & nb)
        | (nc & d  & nb)
        | (c  & nd & na)
        | (c  & d  & a)
        | (c  & d  & b);

endmodule