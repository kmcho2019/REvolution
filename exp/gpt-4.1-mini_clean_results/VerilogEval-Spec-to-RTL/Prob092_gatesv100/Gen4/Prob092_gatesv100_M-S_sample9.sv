module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// For out_both[i], check in[i] & in[i+1] with zero padding at MSB (no left neighbor for bit 99)
assign out_both = in & {in[98:0], 1'b0};

// For out_any[i], check in[i] | in[i-1] with zero padding at LSB (no right neighbor for bit 0)
assign out_any  = in | {1'b0, in[99:1]};

// For out_different[i], XOR with left neighbor, wrapping around
assign out_different = in ^ {in[0], in[99:1]};

endmodule