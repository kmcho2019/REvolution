// TopModule: A simplified combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Calculate the XOR of a, b, c, and d
    logic xor_result;
    assign xor_result = a ^ b ^ c ^ d;

    // Invert the XOR result to get the output q
    assign q = ~xor_result;

endmodule