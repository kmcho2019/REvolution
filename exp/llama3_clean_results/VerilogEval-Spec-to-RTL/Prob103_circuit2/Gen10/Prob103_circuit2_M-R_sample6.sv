// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate variables to calculate the XOR of pairs of inputs
    logic ab_xor;  // XOR of a and b
    logic cd_xor;  // XOR of c and d
    logic final_xor;  // Final XOR result before inversion

    // Calculate the XOR of a and b
    assign ab_xor = a ^ b;
    
    // Calculate the XOR of c and d
    assign cd_xor = c ^ d;
    
    // Calculate the XOR of the two intermediate results
    assign final_xor = ab_xor ^ cd_xor;
    
    // The output q is the inverse of the final XOR result
    assign q = ~final_xor;

endmodule