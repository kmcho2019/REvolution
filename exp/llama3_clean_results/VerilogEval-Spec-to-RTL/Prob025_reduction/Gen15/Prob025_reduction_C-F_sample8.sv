// Superior module combining the strengths of hierarchical XOR tree and direct XOR operation
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the even parity bit using a simplified hierarchical XOR tree structure
wire pair1, pair2, pair3, pair4;
assign pair1 = in[0] ^ in[1] ^ in[2] ^ in[3]; // Simplified to directly compute XOR of first 4 bits
assign pair2 = in[4] ^ in[5] ^ in[6] ^ in[7]; // Simplified to directly compute XOR of last 4 bits

assign parity = pair1 ^ pair2; // Final XOR to compute the parity bit

endmodule