module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99] = 0 (no left neighbor)
    // Shift left by 1 aligns each bit with its left neighbor.
    wire [99:0] in_left_shifted = {in[98:0], 1'b0};
    assign out_both = in & in_left_shifted;

    // out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0] = 0 (no right neighbor)
    // Shift right by 1 aligns each bit with its right neighbor.
    wire [99:0] in_right_shifted = {1'b0, in[99:1]};
    assign out_any = in | in_right_shifted;

    // out_different[i] = in[i] ^ in[left_neighbor] with wrap-around:
    // The left neighbor of in[99] is in[0].
    // Construct left neighbor vector by left-shifting in and inserting in[0] at LSB.
    wire [99:0] in_left_neighbor = {in[98:0], in[99]};
    assign out_different = in ^ in_left_neighbor;

endmodule