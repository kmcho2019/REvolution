// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate variables to hold partial XOR results
    logic ab_xor;  // XOR of a and b
    logic cd_xor;  // XOR of c and d
    logic final_xor;  // Final XOR of ab_xor and cd_xor

    // Calculate XOR of a and b
    assign ab_xor = a ^ b;
    
    // Calculate XOR of c and d
    assign cd_xor = c ^ d;
    
    // Calculate final XOR of ab_xor and cd_xor
    assign final_xor = ab_xor ^ cd_xor;
    
    // The output q is the inverse of the final XOR
    assign q = ~final_xor;

endmodule