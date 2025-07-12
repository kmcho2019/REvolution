module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shifted versions of input
    wire [3:0] in_shifted_right = {1'b0, in[3:1]};  // Right shift (for left neighbor)
    wire [3:0] in_shifted_left = {in[2:0], 1'b0};   // Left shift (for right neighbor)
    wire [3:0] in_rotated_right = {in[0], in[3:1]}; // Circular right rotation

    // out_both: AND with right-shifted (left neighbor)
    assign out_both = {1'b0, in[2:0] & in_shifted_right[2:0]};

    // out_any: OR with left-shifted (right neighbor)
    assign out_any = {in[3:1] | in_shifted_left[3:1], 1'b0};

    // out_different: XOR with rotated version (circular difference)
    assign out_different = in ^ in_rotated_right;

endmodule