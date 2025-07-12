module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// Create left neighbor vector for out_both:
// Bits 0..98 compare with in[1..99], bit 99 has no left neighbor -> zero.
// Construct vector as in[99:1] concatenated with 1'b0 for bit 99 neighbor.
wire [99:0] left_neighbor_both = {in[99:1], 1'b0};

// out_both[i] = in[i] & left_neighbor_both[i]
assign out_both = in & left_neighbor_both;

// Create right neighbor vector for out_any:
// Bits 1..99 compare with in[0..98], bit 0 has no right neighbor -> zero.
// Construct vector as 1'b0 concatenated with in[99:1].
wire [99:0] right_neighbor_any = {1'b0, in[99:1]};

// out_any[i] = in[i] | right_neighbor_any[i]
assign out_any = in | right_neighbor_any;

// out_different[i] = in[i] ^ in[(i+1) mod 100]
// Wrap-around neighbor vector for XOR: {in[0], in[99:1]}
assign out_different = in ^ {in[0], in[99:1]};

endmodule