// Improved module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Divide the input byte into two 4-bit groups and compute their parities
wire parity_4bit_1 = in[7] ^ in[6] ^ in[5] ^ in[4];
wire parity_4bit_2 = in[3] ^ in[2] ^ in[1] ^ in[0];

// Compute the final parity by XORing the parities of the two groups
assign parity = parity_4bit_1 ^ parity_4bit_2;

endmodule