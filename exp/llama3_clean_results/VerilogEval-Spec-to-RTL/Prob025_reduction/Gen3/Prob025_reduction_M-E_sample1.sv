module TopModule(
    input [7:0] in,
    output parity
);

wire [3:0] group_xors;

// Calculate XOR of each group of two bits
assign group_xors[0] = in[0] ^ in[1];
assign group_xors[1] = in[2] ^ in[3];
assign group_xors[2] = in[4] ^ in[5];
assign group_xors[3] = in[6] ^ in[7];

// Calculate final parity by XORing the group results
assign parity = group_xors[0] ^ group_xors[1] ^ group_xors[2] ^ group_xors[3];

endmodule