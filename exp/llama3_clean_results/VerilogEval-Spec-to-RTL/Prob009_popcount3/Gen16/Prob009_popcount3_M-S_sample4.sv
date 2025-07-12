module TopModule(
    input [2:0] in,  // 3-bit input vector
    output [1:0] out // 2-bit output vector to hold the population count
);

    // Directly sum the bits of the input vector to get the population count
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule