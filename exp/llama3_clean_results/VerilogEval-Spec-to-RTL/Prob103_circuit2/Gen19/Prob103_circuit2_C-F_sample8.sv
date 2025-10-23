// Superior TopModule: Implementing the inverse XOR logic using a K-map based approach
module TopModule(
    input  logic a,  // Input bit a
    input  logic b,  // Input bit b
    input  logic c,  // Input bit c
    input  logic d,  // Input bit d
    output logic q   // Output bit q
);

    // Count the number of 1s among the inputs
    logic count;
    assign count = (a ^ b ^ c ^ d);

    // Determine the output based on the count
    assign q = ~count;

endmodule