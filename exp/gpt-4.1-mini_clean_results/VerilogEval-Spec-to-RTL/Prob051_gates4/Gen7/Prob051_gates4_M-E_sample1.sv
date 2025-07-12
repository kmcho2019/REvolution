module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

// Intermediate wires for AND
wire and0, and1;
// Intermediate wires for OR
wire or0, or1;
// Intermediate wires for XOR
wire xor0, xor1;

// Two-input AND gates
assign and0 = in[0] & in[1];
assign and1 = in[2] & in[3];
assign out_and = and0 & and1;

// Two-input OR gates
assign or0 = in[0] | in[1];
assign or1 = in[2] | in[3];
assign out_or = or0 | or1;

// Two-input XOR gates
assign xor0 = in[0] ^ in[1];
assign xor1 = in[2] ^ in[3];
assign out_xor = xor0 ^ xor1;

endmodule