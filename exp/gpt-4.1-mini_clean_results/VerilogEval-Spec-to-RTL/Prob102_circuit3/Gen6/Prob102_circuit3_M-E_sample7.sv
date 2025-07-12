module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire na, nb, nc, nd;
    wire and1, and2;
    wire or_out;

    assign na = ~a;
    assign nb = ~b;
    assign nc = ~c;
    assign nd = ~d;

    assign and1 = na & nb;
    assign and2 = nc & nd;

    assign or_out = and1 | and2;

    assign q = ~or_out;

endmodule