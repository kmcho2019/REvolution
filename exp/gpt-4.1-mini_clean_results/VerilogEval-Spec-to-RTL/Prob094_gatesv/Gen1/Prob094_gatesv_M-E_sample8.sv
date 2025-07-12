module TopModule (
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] in_left_shifted;
    wire [3:0] in_right_shifted;
    wire [3:0] in_rotated_left;

    // Shift input left by 1 bit, fill LSB with 0
    assign in_left_shifted = {in[2:0], 1'b0};

    // Shift input right by 1 bit, fill MSB with 0
    assign in_right_shifted = {1'b0, in[3:1]};

    // Circular left shift by 1 bit (wrap around)
    assign in_rotated_left = {in[2:0], in[3]};

    // out_both: bits 0-2 = in & (in shifted left by 1); bit 3 = 0
    assign out_both = (in & in_left_shifted) & 4'b0111;

    // out_any: bits 1-3 = in | (in shifted right by 1); bit 0 = 0
    assign out_any = (in | in_right_shifted) & 4'b1110;

    // out_different: XOR input with its circular left shift
    assign out_different = in ^ in_rotated_left;

endmodule