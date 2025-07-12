module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Even parity output: q is high when the number of inputs set is even
    assign q = ~(a ^ b ^ c ^ d);

endmodule