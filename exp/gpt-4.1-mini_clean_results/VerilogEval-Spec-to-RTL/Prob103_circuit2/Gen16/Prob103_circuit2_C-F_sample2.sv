module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire w1, w2;

    // Balanced XNOR tree for even parity
    assign w1 = a ~^ b;
    assign w2 = c ~^ d;
    assign q  = w1 ~^ w2;

endmodule