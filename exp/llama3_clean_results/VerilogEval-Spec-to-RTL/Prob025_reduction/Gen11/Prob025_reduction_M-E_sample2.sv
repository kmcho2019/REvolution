module TopModule(
    input [7:0] in,  // 8-bit input
    output parity  // 1-bit parity output
);

wire parity_group1, parity_group2, parity_group3, parity_group4;

// Compute parity for each 2-bit group
assign parity_group1 = in[1] ^ in[0];
assign parity_group2 = in[3] ^ in[2];
assign parity_group3 = in[5] ^ in[4];
assign parity_group4 = in[7] ^ in[6];

// Combine parities of groups to get final parity
assign parity = parity_group1 ^ parity_group2 ^ parity_group3 ^ parity_group4;

endmodule