// Simplified TopModule: Direct implementation of the inverse XOR logic
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Directly compute the output q as the inverse of the XOR of (a^b) and (c^d)
    assign q = ~(a ^ b ^ c ^ d); // Simplified XOR and NOT operation

endmodule