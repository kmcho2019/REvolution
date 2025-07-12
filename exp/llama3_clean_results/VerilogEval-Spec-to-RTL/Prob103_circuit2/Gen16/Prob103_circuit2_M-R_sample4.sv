// Refactored TopModule: Simplified implementation
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Directly assign output q based on the XOR and NOT operations
    assign q = ~(a ^ b ^ c ^ d); // Simplified logic expression

    // Synthesis directive remains the same for optimization
    // Example directive for optimizing area (actual directive may vary based on the synthesis tool)
    // pragma synthesis optimize_area

endmodule