module TopModule(
    input  [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    // Shift left by 1 to align neighbors to the left
    wire [3:0] in_left = {in[2:0], 1'b0};  // in[3] has no left neighbor, zero fill LSB

    // Shift right by 1 to align neighbors to the right
    wire [3:0] in_right = {1'b0, in[3:1]}; // in[0] has no right neighbor, zero fill MSB

    // Circular left rotate by 1 for wrap-around neighbor on left
    wire [3:0] in_rot_left = {in[2:0], in[3]}; // in[3]'s neighbor is in[0]

    // out_both: bits where both bit and left neighbor are 1; out_both[3]=0 as no left neighbor
    assign out_both = (in & in_left) & 4'b0111;

    // out_any: bits where bit or right neighbor is 1; out_any[0]=0 as no right neighbor
    assign out_any = (in | in_right) & 4'b1110;

    // out_different: bits differ from left neighbor considering wrap-around
    assign out_different = in ^ in_rot_left;

endmodule