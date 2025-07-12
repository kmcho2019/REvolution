module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Even parity output: reduction XNOR (^~) computes complement of XOR of all inputs
    assign q = ^~{a, b, c, d};

endmodule