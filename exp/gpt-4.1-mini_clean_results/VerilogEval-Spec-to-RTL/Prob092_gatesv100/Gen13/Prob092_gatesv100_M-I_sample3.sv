module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// Compute left neighbor vector with wrap-around:
// left_neighbor[i] = in[(i+1) % 100]
wire [99:0] left_neighbor = {in[0], in[99:1]};

// Compute right neighbor vector with zero-padding:
// right_neighbor[i] = in[i-1] for i>=1, right_neighbor[0]=0
wire [99:0] right_neighbor = {in[98:0], 1'b0};

// (1) out_both[i] = in[i] & left_neighbor[i] for i=0..98
// out_both[99] = 0 because in[99] has no left neighbor
assign out_both = in & left_neighbor;
assign out_both[99] = 1'b0; // enforce zero for MSB as per spec

// (2) out_any[i] = in[i] | right_neighbor[i] for i=1..99
// out_any[0] = 0 because in[0] has no right neighbor
assign out_any = in | right_neighbor;
assign out_any[0] = 1'b0; // enforce zero for LSB as per spec

// (3) out_different[i] = in[i] ^ left_neighbor[i] for i=0..99 with wrap
assign out_different = in ^ left_neighbor;

endmodule