// Simplified TopModule: Implementing the inverse XOR logic
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Determine the output based on the XOR of all inputs
    assign q = ~(a ^ b ^ c ^ d);

endmodule