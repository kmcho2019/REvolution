module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector to hold the population count
);

    // Directly sum the bits of the input vector to get the population count
    // Using a temporary variable for clarity and potential ease of expansion
    wire [1:0] temp_sum;
    assign temp_sum = in[0] + in[1] + in[2];
    assign out = temp_sum;

endmodule