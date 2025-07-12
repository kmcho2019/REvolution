module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_right, in_shifted_left;

    // Shift the input vector one bit to the right
    assign in_shifted_right = {1'b0, in[99:1]};

    // Shift the input vector one bit to the left
    assign in_shifted_left = {in[98:0], 1'b0};

    // Compute out_both
    assign out_both = in & in_shifted_right;

    // Compute out_any
    assign out_any = in | in_shifted_left;

    // Compute out_different with wrap-around
    assign out_different = in ^ ((in[99] ^ in[0]) ? {in[0], in[99:1]} : in);

endmodule