module TopModule(
    input [2:0] in,  // 3-bit input
    output [1:0] out  // 2-bit output
);

    // Calculate the population count
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

endmodule