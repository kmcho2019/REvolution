module TopModule (
    input a,
    input b,
    input c,
    input d,
    output q
);

// Output is 1 when number of 1s in inputs is even (0, 2, or 4)
// Implemented as 4-bit XOR parity function (q = ~(a^b^c^d))
assign q = ~(a ^ b ^ c ^ d);

endmodule