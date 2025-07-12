module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Create rotated versions of input
    wire [3:0] rot_left = {in[2:0], in[3]};  // Rotated left by 1
    wire [3:0] rot_right = {in[0], in[3:1]}; // Rotated right by 1

    // Mask vectors for boundary conditions
    wire [3:0] both_mask = 4'b0111;
    wire [3:0] any_mask = 4'b1110;

    // out_both: AND with left neighbor (mask MSB)
    assign out_both = (in & rot_right) & both_mask;

    // out_any: OR with right neighbor (mask LSB)
    assign out_any = (in | rot_left) & any_mask;

    // out_different: XOR with left neighbor (circular)
    assign out_different = in ^ rot_right;

endmodule