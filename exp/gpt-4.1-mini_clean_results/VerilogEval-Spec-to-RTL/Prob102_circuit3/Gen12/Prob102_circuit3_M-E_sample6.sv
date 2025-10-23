module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire na, nb, nc, nd;
    wire term1, term2;

    assign na = ~a;
    assign nb = ~b;
    assign nc = ~c;
    assign nd = ~d;

    assign term1 = na & nb;
    assign term2 = nc & nd;

    assign q = ~(term1 | term2);

endmodule