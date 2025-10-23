module TopModule (
    input  wire [3:0] in,
    output wire [3:0] out_both,
    output wire [3:0] out_any,
    output wire [3:0] out_different
);

    // Neighbor to the left shifted input for out_both: in shifted left by 1 bit, 0 padded
    wire [3:0] in_left = {in[2:0], 1'b0}; // in[3]'s neighbor to left doesn't exist => 0

    // Neighbor to the right shifted input for out_any: in shifted right by 1 bit, 0 padded
    wire [3:0] in_right = {1'b0, in[3:1]}; // in[0]'s neighbor to right doesn't exist => 0

    // Rotated input by left shift 1 with wrap-around for out_different
    wire [3:0] in_rot = {in[2:0], in[3]};

    // out_both[i] = in[i] & in[i+1] for i<3, else 0
    assign out_both = in & in_left;

    // out_any[i] = in[i] | in[i-1] for i>0, else 0
    assign out_any = in | in_right;

    // out_different[i] = in[i] ^ in[(i+1) mod 4]
    assign out_different = in ^ in_rot;

endmodule