// Novel TopModule: A counter-based implementation
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Count the number of 1s among the inputs
    wire count_0;
    assign count_0 = (a ^ b) ^ (c ^ d); // XOR of pairs of inputs
    
    // Determine if the count is even (count_1 == 0) or odd (count_1 == 1)
    assign q = ~count_0; // Invert the result to match the desired output

endmodule