// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Intermediate wire for XOR of a and b
    logic ab_xor;  
    assign ab_xor = a ^ b;
    
    // Intermediate wire for XOR of c and d
    logic cd_xor;  
    assign cd_xor = c ^ d;
    
    // Intermediate wire for XOR of ab_xor and cd_xor
    logic abcd_xor;  
    assign abcd_xor = ab_xor ^ cd_xor;
    
    // Final output q as the inverse of abcd_xor
    assign q = ~abcd_xor;  

endmodule