module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Intermediate signals for 2-input gates
wire and_01, and_23, or_01, or_23, xor_01, xor_23;

// Compute 2-input gate outputs
assign and_01 = in[0] & in[1];
assign and_23 = in[2] & in[3];
assign or_01  = in[0] | in[1];
assign or_23  = in[2] | in[3];
assign xor_01 = in[0] ^ in[1];
assign xor_23 = in[2] ^ in[3];

// Compute final outputs using intermediate signals
assign out_and = and_01 & and_23;
assign out_or  = or_01  | or_23;
assign out_xor = xor_01 ^ xor_23;

endmodule