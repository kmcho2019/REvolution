module TopModule(
    input [7:0] in,
    output parity
);

// Divide the 8-bit input into two 4-bit groups
wire group1_parity, group2_parity;

// Compute the XOR of the first 4 bits
assign group1_parity = in[0] ^ in[1] ^ in[2] ^ in[3];

// Compute the XOR of the last 4 bits
assign group2_parity = in[4] ^ in[5] ^ in[6] ^ in[7];

// Compute the final parity by XORing the two group parities
assign parity = group1_parity ^ group2_parity;

endmodule