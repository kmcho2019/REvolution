// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate signals to break down the XOR operation
    logic xor_ab;  // XOR of a and b
    logic xor_abc; // XOR of (a ^ b) and c
    logic xor_abcd; // XOR of ((a ^ b) ^ c) and d

    // Calculate the XOR of a and b
    assign xor_ab = a ^ b;
    
    // Calculate the XOR of (a ^ b) and c
    assign xor_abc = xor_ab ^ c;
    
    // Calculate the XOR of ((a ^ b) ^ c) and d
    assign xor_abcd = xor_abc ^ d;
    
    // Calculate the inverse XOR by applying NOT to the final XOR result
    assign q = ~xor_abcd;

endmodule