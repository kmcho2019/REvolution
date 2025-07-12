// Improved module to calculate the even parity bit for an 8-bit input byte using a tree structure of XOR gates
module TopModule(
    input  [7:0] in,  // 8-bit input byte
    output parity    // 1-bit output for even parity
);

// Calculate the even parity bit using a tree structure of XOR gates
wire tmp1, tmp2, tmp3, tmp4;
assign tmp1 = in[0] ^ in[1];
assign tmp2 = in[2] ^ in[3];
assign tmp3 = in[4] ^ in[5];
assign tmp4 = in[6] ^ in[7];
assign parity = tmp1 ^ tmp2 ^ tmp3 ^ tmp4;

endmodule