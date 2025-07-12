module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire w1, w2;

    // Balanced 2-input XNOR gates forming a balanced parity tree
    assign w1 = a ~^ b;
    assign w2 = c ~^ d;

    // Final output is the XNOR of intermediate results, yielding even parity
    assign q  = w1 ~^ w2;

endmodule