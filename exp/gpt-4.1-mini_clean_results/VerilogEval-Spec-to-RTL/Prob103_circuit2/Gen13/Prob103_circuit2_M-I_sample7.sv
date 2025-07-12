module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Even parity output: invert the XOR of all inputs using reduction XOR operator
    assign q = ~(^ {a,b,c,d});

endmodule