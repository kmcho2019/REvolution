// Module to calculate the even parity bit for an 8-bit input byte using a hierarchical approach
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the parity for each group of two bits
wire group1_parity = in[0] ^ in[1];
wire group2_parity = in[2] ^ in[3];
wire group3_parity = in[4] ^ in[5];
wire group4_parity = in[6] ^ in[7];

// Combine the parities from each group to obtain the final parity
wire level1_parity1 = group1_parity ^ group2_parity;
wire level1_parity2 = group3_parity ^ group4_parity;

// Final parity calculation
assign parity = level1_parity1 ^ level1_parity2;

endmodule