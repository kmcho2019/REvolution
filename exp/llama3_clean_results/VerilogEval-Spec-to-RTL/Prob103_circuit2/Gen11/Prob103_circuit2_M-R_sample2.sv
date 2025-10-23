// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signals to improve readability
    logic ab_xor;  // XOR of a and b
    logic cd_xor;  // XOR of c and d
    logic all_xor; // XOR of (a^b) and (c^d)

    // Calculate XOR of a and b
    assign ab_xor = a ^ b;

    // Calculate XOR of c and d
    assign cd_xor = c ^ d;

    // Calculate XOR of (a^b) and (c^d)
    assign all_xor = ab_xor ^ cd_xor;

    // The output q is the inverse of the XOR of all input bits
    assign q = ~all_xor;  // Use NOT operator (~) on the final XOR result

endmodule