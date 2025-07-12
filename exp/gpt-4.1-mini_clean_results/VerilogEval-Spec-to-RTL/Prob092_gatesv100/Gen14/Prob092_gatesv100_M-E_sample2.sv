module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

    // Left neighbor vector for out_both: shift in left by 1, pad LSB with 0
    wire [99:0] in_left;
    assign in_left = {in[98:0], 1'b0};  // in_left[i] = in[i-1], left neighbor, zero at i=0

    // For out_both: bit[i] = in[i] & in_left[i]
    // However, per spec, neighbor to the left means in[i] & in[i+1]
    // Since "neighbor to the left" in spec means higher index, actually shift in right by 1 and pad MSB
    wire [99:0] in_left_neighbor;
    assign in_left_neighbor = {1'b0, in[99:1]}; // in_left_neighbor[i] = in[i+1] for i=0..98, in_left_neighbor[99]=0

    assign out_both = in & in_left_neighbor;  // last bit automatically zero due to in_left_neighbor[99]=0

    // Right neighbor for out_any: shift in right by 1, pad MSB with 0
    wire [99:0] in_right_neighbor;
    assign in_right_neighbor = {in[98:0], 1'b0}; // in_right_neighbor[i] = in[i-1], for i=1..99; zero at i=0

    assign out_any = in | in_right_neighbor;  // first bit zero as in_right_neighbor[0]=0

    // For out_different: left neighbor wraps around, i.e. in_left_neighbor_circular[i] = in[(i+1)%100]
    // Circular left shift of in by 1
    wire [99:0] in_left_circular;
    assign in_left_circular = {in[98:0], in[99]};  // in_left_circular[i] = in[(i+1)%100]

    assign out_different = in ^ in_left_circular;

endmodule