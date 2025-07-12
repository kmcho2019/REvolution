// Novel module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Divide the byte into four groups of 2 bits each and calculate their parities
wire group1_parity = in[1] ^ in[0];
wire group2_parity = in[3] ^ in[2];
wire group3_parity = in[5] ^ in[4];
wire group4_parity = in[7] ^ in[6];

// Calculate the final parity by XORing the group parities
assign parity = group1_parity ^ group2_parity ^ group3_parity ^ group4_parity;

endmodule