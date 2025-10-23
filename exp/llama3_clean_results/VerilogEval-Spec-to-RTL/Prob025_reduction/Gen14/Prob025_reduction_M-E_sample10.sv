// Novel module to calculate the even parity bit for an 8-bit input byte
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the even parity bit using a hierarchical XOR tree structure
wire pair1, pair2, pair3, pair4;
assign pair1 = in[0] ^ in[1];
assign pair2 = in[2] ^ in[3];
assign pair3 = in[4] ^ in[5];
assign pair4 = in[6] ^ in[7];

wire level2_1, level2_2;
assign level2_1 = pair1 ^ pair2;
assign level2_2 = pair3 ^ pair4;

assign parity = level2_1 ^ level2_2;

endmodule