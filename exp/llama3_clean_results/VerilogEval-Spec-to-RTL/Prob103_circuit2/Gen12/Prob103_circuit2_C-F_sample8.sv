// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // The output q is the inverse of the XOR of all input bits, which is equivalent to
    // the parity generator's output inverted. This is because the XOR of a set of bits
    // is 1 if there is an odd number of 1's in the set, and 0 if there is an even number.
    // We use the XOR operator (^) followed by the NOT operator (~) for simplicity and efficiency.
    assign q = ~(a ^ b ^ c ^ d);

endmodule