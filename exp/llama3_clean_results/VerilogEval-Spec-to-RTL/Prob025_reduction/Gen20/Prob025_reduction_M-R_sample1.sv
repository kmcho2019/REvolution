// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Intermediate wires to hold the parities of the two 4-bit groups
wire group1_parity;
wire group2_parity;

// Calculate the parity of the first 4 bits (in[7:4])
assign group1_parity = in[7] ^ in[6] ^ in[5] ^ in[4];

// Calculate the parity of the second 4 bits (in[3:0])
assign group2_parity = in[3] ^ in[2] ^ in[1] ^ in[0];

// Calculate the final parity by XORing the parities of the two groups
assign parity = group1_parity ^ group2_parity;

endmodule