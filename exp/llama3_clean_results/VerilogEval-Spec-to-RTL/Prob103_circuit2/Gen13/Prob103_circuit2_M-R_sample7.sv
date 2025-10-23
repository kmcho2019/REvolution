// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate wires to hold XOR results
    logic ab_xor;  // XOR of a and b
    logic abc_xor; // XOR of (a ^ b) and c

    // Calculate XOR of a and b
    assign ab_xor = a ^ b;

    // Calculate XOR of (a ^ b) and c
    assign abc_xor = ab_xor ^ c;

    // Calculate final XOR of (a ^ b ^ c) and d
    assign q = ~(abc_xor ^ d);  // Use XOR operator (^) followed by NOT operator (~)

endmodule