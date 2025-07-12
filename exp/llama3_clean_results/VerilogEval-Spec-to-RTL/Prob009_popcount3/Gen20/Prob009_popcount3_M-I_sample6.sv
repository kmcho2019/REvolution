module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out  // 2-bit output vector to hold the population count
);

    // Calculate the population count
    wire [1:0] count = in[0] + in[1] + in[2];

    // Saturate the output if the count exceeds the maximum representable value
    assign out = (count > 3)? 2'b11 : count[1:0];

endmodule