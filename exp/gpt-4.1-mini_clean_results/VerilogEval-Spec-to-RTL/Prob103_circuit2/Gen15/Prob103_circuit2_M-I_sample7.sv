module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire w1, w2;
    // Balanced XOR tree for inputs
    assign w1 = a ^ b;
    assign w2 = c ^ d;
    // Final output is XNOR of two XOR results -> even parity
    assign q = w1 ~^ w2;

endmodule