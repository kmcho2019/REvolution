module TopModule(
    input [2:0] in,
    output [1:0] out
);

    assign out = {in[0] + in[1] + in[2], in[0] + in[1] + in[2]};

    // Alternatively, to correctly handle the 2-bit output:
    assign out = {1'b0, in[0] + in[1] + in[2]};

    // Correct implementation to ensure proper bit width handling:
    assign out = in[0] + in[1] + in[2];

endmodule