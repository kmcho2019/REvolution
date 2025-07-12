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
    // To optimize for PPA, we consider the direct implementation of this logic.
    assign q = ~(a ^ b ^ c ^ d);  // Use XOR operator (^) followed by NOT operator (~)

    // Consideration for optimization:
    // - For performance, the current implementation is straightforward and does not appear to have long critical paths.
    // - For power, the implementation does not seem to have areas of high switching activity that could be optimized.
    // - For area, the implementation involves a minimal number of logic gates (XOR and NOT), which is already quite area-efficient.

endmodule