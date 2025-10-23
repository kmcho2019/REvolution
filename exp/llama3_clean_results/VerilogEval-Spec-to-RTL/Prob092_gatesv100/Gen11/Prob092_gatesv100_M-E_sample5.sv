module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Shift the input vector to the right by one bit
    wire [99:0] in_shifted_right;
    assign in_shifted_right = {1'b0, in[99:1]};

    // Shift the input vector to the left by one bit
    wire [99:0] in_shifted_left;
    assign in_shifted_left = {in[98:0], 1'b0};

    // Calculate out_both
    assign out_both = in & in_shifted_right;

    // Calculate out_any
    assign out_any = in | in_shifted_left;

    // Calculate out_different
    wire [99:0] out_different_no_wrap;
    assign out_different_no_wrap = in ^ in_shifted_right;

    // Handle the wrap-around case for out_different
    assign out_different[99] = in[99] ^ in[0];
    assign out_different[98:0] = out_different_no_wrap[98:0];

endmodule