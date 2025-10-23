module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shift the input vector to the left by one position for out_both
    wire [99:0] in_shifted_left;
    assign in_shifted_left[0] = 1'b0; // Shift in a 0 from the left
    assign in_shifted_left[99:1] = in[98:0];

    // Shift the input vector to the right by one position for out_any and out_different
    wire [99:0] in_shifted_right;
    assign in_shifted_right[99] = 1'b0; // Shift in a 0 from the right
    assign in_shifted_right[98:0] = in[99:1];

    // Compute out_both
    assign out_both = in & in_shifted_left;

    // Compute out_any
    assign out_any = in | in_shifted_right;

    // Compute out_different with wrap-around for the last bit
    wire [99:0] in_shifted_right_wrap;
    assign in_shifted_right_wrap[99] = in[0]; // Wrap-around for the last bit
    assign in_shifted_right_wrap[98:0] = in[99:1];
    assign out_different = in ^ in_shifted_right_wrap;

endmodule