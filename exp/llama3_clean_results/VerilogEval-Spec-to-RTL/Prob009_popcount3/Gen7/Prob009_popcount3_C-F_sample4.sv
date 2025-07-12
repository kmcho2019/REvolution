// Module to count the number of '1's in a 3-bit input vector
module TopModule(
    input [2:0] input_vector,  // 3-bit input vector
    output [1:0] population_count // 2-bit output vector to hold the count
);

    // Assign the count of '1's in the input vector to the output
    // This is done by directly adding the bits of the input vector, treating each bit as an integer
    assign population_count = input_vector[0] + input_vector[1] + input_vector[2];

endmodule