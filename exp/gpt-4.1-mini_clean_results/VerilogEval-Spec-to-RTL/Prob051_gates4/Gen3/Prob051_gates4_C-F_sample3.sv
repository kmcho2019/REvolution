module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Use reduction operators for AND and OR for conciseness and minimal logic
assign out_and = &in;
assign out_or  = |in;

// Implement XOR as a balanced 2-stage tree for potential optimized XOR mapping
wire xor_pair0, xor_pair1;
assign xor_pair0 = in[0] ^ in[1];
assign xor_pair1 = in[2] ^ in[3];
assign out_xor = xor_pair0 ^ xor_pair1;

endmodule