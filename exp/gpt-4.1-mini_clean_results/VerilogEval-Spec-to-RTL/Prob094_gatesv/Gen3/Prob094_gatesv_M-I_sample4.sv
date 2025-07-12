module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // out_both: AND with left neighbor (higher index)
    // Create shifted 'in' vector left by 1 bit with zero pad at LSB
    wire [3:0] in_shifted_left = {in[2:0], 1'b0};
    assign out_both = (in & in_shifted_left) & 4'b0111; // bit3=0, bits0..2 valid

    // out_any: OR with right neighbor (lower index)
    // Create shifted 'in' vector right by 1 bit with zero pad at MSB
    wire [3:0] in_shifted_right = {1'b0, in[3:1]};
    assign out_any = (in | in_shifted_right) & 4'b1110; // bit0=0, bits1..3 valid

    // out_different: XOR with left neighbor with wrap-around
    // Rotate 'in' left by 1 to get neighbors
    wire [3:0] in_rotated_left = {in[2:0], in[3]};
    assign out_different = in ^ in_rotated_left;

endmodule