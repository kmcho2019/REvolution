module TopModule(
    input [2:0] in, // 3-bit input vector
    output [1:0] out // 2-bit output vector (population count)
);

    // Initialize the output to zero
    assign out = (in[0] ? 1'b1 : 1'b0) + (in[1] ? 1'b1 : 1'b0) + (in[2] ? 1'b1 : 1'b0);

endmodule