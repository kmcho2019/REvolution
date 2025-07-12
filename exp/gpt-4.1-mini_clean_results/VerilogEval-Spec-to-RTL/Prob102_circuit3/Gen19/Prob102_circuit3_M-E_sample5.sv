module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    wire t1 = na & nb;
    wire t2 = nc & nd;
    wire t3 = t1 | t2;
    assign q = ~t3;
endmodule