module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Compute even parity with balanced XOR tree for potentially improved performance
    assign q = ~((a ^ b) ^ (c ^ d));

endmodule