module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Use reduction operators for AND and OR for minimal logic
assign out_and = &in;
assign out_or  = |in;

// For XOR, explicitly use intermediate two-input XORs to clarify gate structure
wire xor0, xor1;
assign xor0 = in[0] ^ in[1];
assign xor1 = in[2] ^ in[3];
assign out_xor = xor0 ^ xor1;

endmodule