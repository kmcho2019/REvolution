// Superior module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Divide the byte into two groups of 4 bits each
wire group1_parity = ^in[3:0];  // XOR reduction for the first 4 bits
wire group2_parity = ^in[7:4];  // XOR reduction for the last 4 bits

// Calculate the final parity by XORing the group parities
assign parity = group1_parity ^ group2_parity;

endmodule