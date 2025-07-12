module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shifted_left, in_shifted_right;

    // Shift input vector to the left for out_any
    assign in_shifted_left = {in[0], in[99:1]};
    // Shift input vector to the right for out_both and out_different
    assign in_shifted_right = {in[98:0], in[99]};

    assign out_both = (in & in_shifted_right);
    assign out_both[99] = 1'b0; // Correct MSB

    assign out_any = (in | in_shifted_left);
    assign out_any[0] = 1'b0; // Correct LSB

    assign out_different = (in ^ in_shifted_right);

endmodule