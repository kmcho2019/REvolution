// Superior TopModule: A balanced implementation combining efficiency and readability
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate wire for XOR of a and b
    wire ab_xor;
    assign ab_xor = a ^ b; // First XOR operation
    
    // Intermediate wire for XOR of c and d
    wire cd_xor;
    assign cd_xor = c ^ d; // Second XOR operation
    
    // Intermediate wire for XOR of ab_xor and cd_xor
    wire xor_result;
    assign xor_result = ab_xor ^ cd_xor; // Final XOR operation
    
    // Final output q as the inverse of xor_result
    assign q = ~xor_result; // NOT operation

    // Synthesis directive to optimize for area, considering the target technology
    // This could involve specific attributes or pragmas supported by the synthesis tool
    // Example directive for optimizing area (actual directive may vary based on the synthesis tool)
    // pragma synthesis optimize_area

endmodule