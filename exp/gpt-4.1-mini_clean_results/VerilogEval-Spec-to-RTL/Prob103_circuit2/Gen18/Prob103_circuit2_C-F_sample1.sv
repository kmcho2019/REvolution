module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Output q is the even parity (4-input XNOR) of inputs a, b, c, d
    assign q = ^~{a, b, c, d};

endmodule