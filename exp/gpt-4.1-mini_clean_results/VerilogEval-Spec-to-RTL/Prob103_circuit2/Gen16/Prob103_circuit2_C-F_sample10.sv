module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity of inputs by reduction XNOR operator
    assign q = ^~{a, b, c, d};

endmodule