module TopModule(
    input  wire [99:0] in,
    output wire [99:0] out_both,
    output wire [99:0] out_any,
    output wire [99:0] out_different
);

// Extended input vectors with zero padding for boundary conditions
wire [100:0] in_both_ext = {in, 1'b0};    // in_ext[i+1] for out_both
wire [100:0] in_any_ext  = {1'b0, in};    // in_ext[i-1] for out_any

// out_both[i] = in[i] & in[i+1], with out_both[99] = in[99] & 0 = 0
assign out_both = in & in_both_ext[100:1];

// out_any[i] = in[i] | in[i-1], with out_any[0] = in[0] | 0 = 0
assign out_any = in | in_any_ext[99:0];

// out_different[i] = in[i] ^ in[(i+1) mod 100], with wrap-around neighbor
assign out_different = in ^ {in[0], in[99:1]};

endmodule