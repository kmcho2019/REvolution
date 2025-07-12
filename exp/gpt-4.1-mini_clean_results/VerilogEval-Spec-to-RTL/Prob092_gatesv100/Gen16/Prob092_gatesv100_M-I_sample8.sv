module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Left neighbors for out_both: in shifted left by 1 bit, MSB padded with 0
    wire [99:0] in_left = {in[98:0], 1'b0};

    // Right neighbors for out_any: in shifted right by 1 bit, LSB padded with 0
    wire [99:0] in_right = {1'b0, in[99:1]};

    // Left neighbors for out_different with wrap-around: rotate in left by 1
    wire [99:0] in_left_wrap = {in[98:0], in[99]};

    // Compute out_both: bitwise AND of in and left neighbor, zero bit 99
    assign out_both = (in & in_left) & {99{1'b1}, 1'b0};

    // Compute out_any: bitwise OR of in and right neighbor, zero bit 0
    assign out_any = (in | in_right) & {1'b0, 99{1'b1}};

    // Compute out_different: bitwise XOR of in and left neighbor with wrap-around
    assign out_different = in ^ in_left_wrap;

endmodule