module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Intermediate wires for neighbors to assist synthesis
    wire [98:0] in_left_neighbors = in[99:1];  // Neighbors to the left (for bits 0 to 98)
    wire [98:0] in_right_neighbors = in[98:0]; // Neighbors to the right (for bits 1 to 99)

    // out_both[i] = in[i] & in[i+1] for i=0..98; out_both[99] = 0 (no left neighbor)
    // Using non-overlapping slice to reduce fanout on any single bit
    assign out_both[98:0] = in[98:0] & in_left_neighbors;
    assign out_both[99] = 1'b0;

    // out_any[i] = in[i] | in[i-1] for i=1..99; out_any[0] = 0 (no right neighbor)
    assign out_any[99:1] = in[99:1] | in_right_neighbors;
    assign out_any[0] = 1'b0;

    // out_different[i] = in[i] ^ in[(i-1) mod 100] with wrap-around
    wire [99:0] in_rotated_left = {in[0], in[99:1]}; // neighbor to the left with wrap-around
    assign out_different = in ^ in_rotated_left;

endmodule