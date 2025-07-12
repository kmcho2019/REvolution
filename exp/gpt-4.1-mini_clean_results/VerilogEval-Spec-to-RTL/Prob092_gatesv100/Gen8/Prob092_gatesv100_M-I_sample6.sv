module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Create shifted versions of 'in' for neighbors
    wire [98:0] in_left_neighbors = in[99:1];   // neighbors to left for bits 0..98
    wire [98:0] in_right_neighbors = in[98:0]; // neighbors to right for bits 1..99

    // out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99] = 0
    assign out_both[98:0] = in[98:0] & in_left_neighbors;
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0] = 0
    assign out_any[99:1] = in[99:1] | in_right_neighbors;
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i+1) mod 100] with wrap-around neighbor
    assign out_different = in ^ {in[0], in[99:1]};

endmodule