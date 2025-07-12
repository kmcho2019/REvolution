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

    wire w1 = na & nb;
    wire w2 = nc & nd;

    assign q = ~(w1 | w2);

endmodule