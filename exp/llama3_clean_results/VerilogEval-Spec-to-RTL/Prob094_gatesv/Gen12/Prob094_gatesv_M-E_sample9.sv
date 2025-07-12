module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift input vector to the left
    wire [3:0] in_shift_left;
    assign in_shift_left = {in[2:0], 1'b0};

    // Shift input vector to the right
    wire [3:0] in_shift_right;
    assign in_shift_right = {1'b0, in[3:1]};

    // Compute out_both
    assign out_both[0] = in[0] & in[1];
    assign out_both[1] = in[1] & in[2];
    assign out_both[2] = in[2] & in[3];
    assign out_both[3] = 1'b0;

    // Compute out_any
    assign out_any[0] = in[0] | in_shift_right[0];
    assign out_any[1] = in[1] | in_shift_right[1];
    assign out_any[2] = in[2] | in_shift_right[2];
    assign out_any[3] = in[3];

    // Compute out_different
    wire [3:0] in_wrap;
    assign in_wrap = {in[0], in[3:1]};
    assign out_different = in ^ in_wrap;

endmodule