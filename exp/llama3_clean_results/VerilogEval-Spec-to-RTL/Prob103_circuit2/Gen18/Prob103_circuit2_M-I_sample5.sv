// Improved TopModule: Optimized implementation using a simplified counting logic
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Simplified counting logic using XOR
    assign q = ~(a ^ b ^ c ^ d);

endmodule