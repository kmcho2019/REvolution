// Refactored module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Intermediate wires to explicitly calculate the parity
wire p1, p2, p3, p4;

// Calculate parity in stages
assign p1 = in[0] ^ in[1];
assign p2 = in[2] ^ in[3];
assign p3 = in[4] ^ in[5];
assign p4 = in[6] ^ in[7];

// Final parity calculation
assign parity = p1 ^ p2 ^ p3 ^ p4;

endmodule