// Refactored TopModule: Implementing the inverse XOR logic using a K-map based approach
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Use a logical expression to determine the output based on the parity of the input bits
    assign q = ~(a ^ b ^ c ^ d);

endmodule