module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

// 2-input AND gates
wire and_12;
assign and_12 = in[0] & in[1];

wire and_34;
assign and_34 = in[2] & in[3];

// Final AND gate
assign out_and = and_12 & and_34;

// 2-input OR gates
wire or_12;
assign or_12 = in[0] | in[1];

wire or_34;
assign or_34 = in[2] | in[3];

// Final OR gate
assign out_or = or_12 | or_34;

// 2-input XOR gates
wire xor_12;
assign xor_12 = in[0] ^ in[1];

wire xor_34;
assign xor_34 = in[2] ^ in[3];

// Final XOR gate using the property that A ^ B ^ C ^ D = (A ^ B) ^ (C ^ D)
assign out_xor = xor_12 ^ xor_34;

endmodule