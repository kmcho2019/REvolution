module TopModule(
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    wire [99:0] in_shift_left;
    wire [99:0] in_shift_right;

    assign in_shift_left = {in[98:0], in[99]};
    assign in_shift_right = {in[0], in[99:1]};

    assign out_both = in & in_shift_left;
    assign out_any = in | in_shift_right;
    assign out_different = in ^ in_shift_left;

endmodule