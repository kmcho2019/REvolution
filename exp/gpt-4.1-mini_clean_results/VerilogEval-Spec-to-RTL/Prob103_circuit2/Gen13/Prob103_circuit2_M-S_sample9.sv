module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Simplified: directly assign the inverse parity (XNOR of all inputs)
    assign q = ~(a ^ b ^ c ^ d);

endmodule