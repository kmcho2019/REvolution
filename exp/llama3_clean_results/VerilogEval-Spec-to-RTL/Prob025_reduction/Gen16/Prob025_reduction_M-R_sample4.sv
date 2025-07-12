// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the even parity bit using a simplified hierarchical XOR tree structure
assign parity = (in[0] ^ in[1] ^ in[2] ^ in[3]) ^ (in[4] ^ in[5] ^ in[6] ^ in[7]);

endmodule