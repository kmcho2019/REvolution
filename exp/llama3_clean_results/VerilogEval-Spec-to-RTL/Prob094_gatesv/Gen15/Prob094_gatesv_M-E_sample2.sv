module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] in_shift_left;  // Shift in to the left by 1 bit
    wire [3:0] in_shift_right; // Shift in to the right by 1 bit

    // Shift operations
    assign in_shift_left = {in[2:0], 1'b0}; // Shift left and fill with 0
    assign in_shift_right = {1'b0, in[3:1]}; // Shift right and fill with 0

    // Perform bitwise operations
    assign out_both = in & in_shift_left;
    assign out_any = in | in_shift_right;
    assign out_different = in ^ {in_shift_left[2:0], in[3]}; // Wrap-around for the most significant bit

endmodule