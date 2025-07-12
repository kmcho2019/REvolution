module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Directly calculate the population count by summing the individual bits of the input vector
    assign out = in[0] + in[1] + in[2];

    // No additional logic or wires are needed due to the simplicity of the population count calculation
    // and the small input size, ensuring the design remains efficient and combinatorial.

endmodule