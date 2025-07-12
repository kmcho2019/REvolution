// Novel module to calculate the even parity bit for an 8-bit input byte using a hierarchical XOR approach
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Divide the 8-bit input into two 4-bit groups
wire [3:0] group1 = in[7:4];
wire [3:0] group2 = in[3:0];

// Compute the XOR of each 4-bit group
wire xor_group1 = ^group1;
wire xor_group2 = ^group2;

// Compute the final parity by XORing the results of the two groups
assign parity = xor_group1 ^ xor_group2;

endmodule