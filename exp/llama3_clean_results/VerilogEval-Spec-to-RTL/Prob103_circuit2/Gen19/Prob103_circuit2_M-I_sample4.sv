// Improved TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
module TopModule(
    input  logic a = 1'b0,  // Input bit a with default value 0
    input  logic b = 1'b0,  // Input bit b with default value 0
    input  logic c = 1'b0,  // Input bit c with default value 0
    input  logic d = 1'b0,  // Input bit d with default value 0
    output logic q = 1'b0   // Output bit q with default value 0
);

    // The output q is the inverse of the XOR of all input bits.
    // This directly implements the required logic in a concise manner.
    assign q = ~(a ^ b ^ c ^ d);

endmodule