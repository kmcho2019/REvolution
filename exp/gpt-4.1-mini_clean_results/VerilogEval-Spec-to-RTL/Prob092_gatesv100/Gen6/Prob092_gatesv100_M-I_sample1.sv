module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    // Define rotated versions of 'in' for neighbor access
    wire [99:0] in_left  = {in[0],    in[99:1]};  // Rotate left by 1 (wrap-around)
    wire [99:0] in_right = {in[98:0], 1'b0};      // Shift right by 1, zero fill LSB

    // (1) out_both[i] = in[i] & in_left[i], but out_both[99] = 0 because in[99] has no left neighbor
    assign out_both = (in & in_left) & {{99{1'b1}}, 1'b0};  // Mask bit 99 to zero

    // (2) out_any[i] = in[i] | in_right[i], but out_any[0] = 0 because in[0] has no right neighbor
    assign out_any = (in | in_right) & {1'b0, {99{1'b1}}};  // Mask bit 0 to zero

    // (3) out_different[i] = in[i] ^ in_left[i] (wrap-around included)
    assign out_different = in ^ in_left;

endmodule