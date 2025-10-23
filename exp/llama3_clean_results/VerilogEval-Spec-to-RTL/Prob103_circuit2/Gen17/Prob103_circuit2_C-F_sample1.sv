// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Directly calculate the inverse XOR of a, b, c, and d
    assign q = ~(a ^ b ^ c ^ d);

    // Consider adding synthesis directives to guide the tool in optimizing for specific PPA metrics
    // For example, to optimize for area, a synthesis directive could be used to instruct the tool to prioritize area reduction over other metrics

endmodule