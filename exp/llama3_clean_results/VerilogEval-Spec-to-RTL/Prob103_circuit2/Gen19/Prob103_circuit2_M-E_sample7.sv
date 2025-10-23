// Novel TopModule: Implementing the inverse XOR logic using a hierarchical XOR-based approach
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Compute the XOR of pairs of inputs
    logic xor_ab;
    assign xor_ab = a ^ b;

    logic xor_cd;
    assign xor_cd = c ^ d;

    // Combine the results to determine the overall parity
    logic xor_all;
    assign xor_all = xor_ab ^ xor_cd;

    // Determine the output based on the parity
    assign q = ~xor_all;

endmodule