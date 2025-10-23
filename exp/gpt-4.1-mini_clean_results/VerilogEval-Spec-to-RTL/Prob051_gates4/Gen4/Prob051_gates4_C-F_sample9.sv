module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Use concise reduction operators for AND and OR
assign out_and = &in;
assign out_or  = |in;

// Balanced two-stage XOR tree for better timing and synthesis mapping
wire xor_low, xor_high;
assign xor_low  = in[0] ^ in[1];
assign xor_high = in[2] ^ in[3];
assign out_xor  = xor_low ^ xor_high;

endmodule