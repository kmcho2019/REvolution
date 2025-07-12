// Module to count the number of '1's in a 3-bit input vector
module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the count
);

    // Directly assign the sum of the input bits to the output
    assign out = in[0] + in[1] + in[2];

endmodule