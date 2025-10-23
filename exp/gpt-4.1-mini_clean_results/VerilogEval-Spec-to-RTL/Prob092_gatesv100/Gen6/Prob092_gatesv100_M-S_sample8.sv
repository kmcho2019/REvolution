module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// out_both[i] = in[i] & in[i+1], with out_both[99] = 0 since in[99] has no left neighbor
assign out_both = (in & (in << 1)) & {99'b1, 1'b0};

// out_any[i] = in[i] | in[i-1], with out_any[0] = 0 since in[0] has no right neighbor
assign out_any = (in | (in >> 1)) & {1'b0, 99'b1};

// out_different[i] = in[i] ^ in[(i+1) mod 100]
// Create wrapped version: {in[98:0], in[99]}
wire [99:0] in_wrapped = {in[98:0], in[99]};
assign out_different = in ^ in_wrapped;

endmodule