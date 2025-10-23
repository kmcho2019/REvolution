module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// Internal signals for 2-input gate outputs
wire and_12, and_34, or_12, or_34, xor_12, xor_34;

// Implement 2-input gates for the first two and last two inputs
assign and_12 = in[3] & in[2];
assign and_34 = in[1] & in[0];
assign or_12  = in[3] | in[2];
assign or_34  = in[1] | in[0];
assign xor_12 = in[3] ^ in[2];
assign xor_34 = in[1] ^ in[0];

// Combine the outputs of the 2-input gates to get the final 4-input gate outputs
assign out_and = and_12 & and_34;
assign out_or  = or_12  | or_34;
assign out_xor = xor_12 ^ xor_34;

endmodule