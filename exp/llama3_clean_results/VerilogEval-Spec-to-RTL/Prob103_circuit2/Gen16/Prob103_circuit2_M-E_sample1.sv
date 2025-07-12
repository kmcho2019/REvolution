// TopModule: A combinational circuit implementing the inverse XOR of inputs a, b, c, and d
// using a lookup table (LUT) approach
module TopModule(
    input  logic [3:0] inputs,  // Input bits a, b, c, d concatenated
    output logic q             // Output bit q
);

    // Define the LUT contents based on the required output for each input combination
    // For simplicity, we directly assign the expected output values based on the problem description
    // The LUT is essentially a truth table where each row corresponds to an input combination
    // and the column represents the output value for that combination
    logic [15:0] lut_contents = {
        1'b1,  // 0000
        1'b1,  // 0001
        1'b1,  // 0010
        1'b0,  // 0011
        1'b1,  // 0100
        1'b0,  // 0101
        1'b0,  // 0110
        1'b1,  // 0111
        1'b0,  // 1000
        1'b1,  // 1001
        1'b1,  // 1010
        1'b0,  // 1011
        1'b0,  // 1100
        1'b0,  // 1101
        1'b1,  // 1110
        1'b1   // 1111
    };

    // Use the input combination as an index to look up the output value in the LUT
    assign q = lut_contents[inputs];

endmodule