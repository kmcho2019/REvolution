module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// The out_and output is the result of a 4-input AND operation
// We can achieve this by sequentially applying the AND operation
assign out_and = in[3] & in[2] & in[1] & in[0];

// The out_or output is the result of a 4-input OR operation
// Similarly, we apply the OR operation sequentially
assign out_or = in[3] | in[2] | in[1] | in[0];

// The out_xor output is the result of a 4-input XOR operation
// We apply the XOR operation sequentially
assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule