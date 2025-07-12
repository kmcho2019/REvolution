module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    // Even parity detector using parallel XOR tree and XNOR
    // Computes q = (a XOR b) XNOR (c XOR d)
    assign q = ~(a ^ b) ^ ~(c ^ d);  // Equivalent to (a XNOR b) XNOR (c XNOR d)
endmodule