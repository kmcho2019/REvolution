// Improved module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Divide the byte into smaller groups for parity calculation
wire bit0_parity = in[0] ^ in[1];
wire bit1_parity = in[2] ^ in[3];
wire bit2_parity = in[4] ^ in[5];
wire bit3_parity = in[6] ^ in[7];

// Combine the parities of smaller groups in a balanced manner
wire group1_parity = bit0_parity ^ bit1_parity;
wire group2_parity = bit2_parity ^ bit3_parity;

// Calculate the final parity by XORing the group parities
assign parity = group1_parity ^ group2_parity;

endmodule