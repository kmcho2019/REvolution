// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Intermediate wires to hold the results of partial XOR operations
wire partial_xor_1, partial_xor_2, partial_xor_3, partial_xor_4;

// First level of XOR operations: compute XOR of pairs
assign partial_xor_1 = in[0] ^ in[1];
assign partial_xor_2 = in[2] ^ in[3];
assign partial_xor_3 = in[4] ^ in[5];
assign partial_xor_4 = in[6] ^ in[7];

// Second level of XOR operations: compute XOR of the first level results
wire intermediate_xor_1, intermediate_xor_2;

assign intermediate_xor_1 = partial_xor_1 ^ partial_xor_2;
assign intermediate_xor_2 = partial_xor_3 ^ partial_xor_4;

// Final XOR operation to compute the parity bit
assign parity = intermediate_xor_1 ^ intermediate_xor_2;

endmodule