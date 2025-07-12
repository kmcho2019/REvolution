module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// Precompute shifted versions of 'in' for neighbor operations to enable sharing

// For out_both: use in_left = in shifted left by 1 bit (bits 99:1)
wire [98:0] in_left = in[99:1];

// For out_any: use in_right = in shifted right by 1 bit (bits 98:0)
wire [98:0] in_right = in[98:0];

// out_both[i] = in[i] & in[i+1] for i=0..98, out_both[99] = 0 (no left neighbor)
assign out_both[98:0] = in[98:0] & in_left;
assign out_both[99]    = 1'b0;

// out_any[i] = in[i] | in[i-1] for i=1..99, out_any[0] = 0 (no right neighbor)
assign out_any[99:1] = in[99:1] | in_right;
assign out_any[0]    = 1'b0;

// out_different[i] = in[i] ^ in[(i+1) mod 100] with wrap-around rotation
assign out_different = in ^ {in[0], in[99:1]};

endmodule