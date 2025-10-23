// Novel module to calculate the even parity bit for an 8-bit input byte using a tree-like structure of XOR gates
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Intermediate wires for the tree-like structure
wire p1, p2, p3, p4;

// Level 1: Compute partial parities
assign p1 = in[0] ^ in[1];
assign p2 = in[2] ^ in[3];
assign p3 = in[4] ^ in[5];
assign p4 = in[6] ^ in[7];

// Level 2: Further combine partial parities
wire p12, p34;
assign p12 = p1 ^ p2;
assign p34 = p3 ^ p4;

// Final level: Compute the overall parity
assign parity = p12 ^ p34;

endmodule