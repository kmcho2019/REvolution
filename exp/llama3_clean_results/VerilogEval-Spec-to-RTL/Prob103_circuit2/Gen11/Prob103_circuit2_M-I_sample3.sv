// TopModule: An optimized combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Alternative implementation using a single XOR gate for all inputs
    // This approach minimizes the number of operations and reduces switching activity
    assign q = ~(a ^ b ^ c ^ d);

    // Consider adding synthesis directives or constraints to optimize for target technology
    // For example, to optimize for area:
    // (* area_optimized = "yes" *)
    // assign q = ~(a ^ b ^ c ^ d);

endmodule