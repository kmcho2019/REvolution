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
    // cd=00 (c=0,d=0): cells with out=1 at ab=00,01,10
    (nc & nd & ((na & nb) | (na & b) | (a & nb))) |
    // cd=01 (c=0,d=1): cells with out=1 at ab=00,10
    (nc & d  & ((na & nb) | (a & nb))) |
    // cd=11 (c=1,d=1): cells with out=1 at ab=01,11,10
    (c  & d  & ((na & b)  | (a & b)  | (a & nb))) |
    // cd=10 (c=1,d=0): cells with out=1 at ab=00,01
    (c  & nd & ((na & nb) | (na & b)));

endmodule