module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity: q is the inverted XOR (XNOR) of all inputs using reduction XOR operator
    assign q = ~(^ {a, b, c, d});
endmodule