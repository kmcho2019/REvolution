module TopModule(
    input  [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector
);

    // Assign the input vector to individual wires
    wire in0 = in[0];
    wire in1 = in[1];
    wire in2 = in[2];

    // Calculate the population count
    assign out[0] = in0 ^ in1 ^ in2;  // XOR of all three inputs for the least significant bit
    assign out[1] = (in0 & in1) | (in0 & in2) | (in1 & in2);  // Majority function for the most significant bit

endmodule