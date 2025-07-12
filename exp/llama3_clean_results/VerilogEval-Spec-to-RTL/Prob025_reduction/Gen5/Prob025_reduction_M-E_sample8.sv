module TopModule(
    input [7:0] in,  // 8-bit input
    output parity   // 1-bit parity output
);

wire [3:0] stage1; // Intermediate results after first level of XOR
wire [1:0] stage2; // Intermediate results after second level of XOR

// First level of XOR: Pairwise XOR of input bits
assign stage1[0] = in[0] ^ in[1];
assign stage1[1] = in[2] ^ in[3];
assign stage1[2] = in[4] ^ in[5];
assign stage1[3] = in[6] ^ in[7];

// Second level of XOR: Pairwise XOR of stage1 results
assign stage2[0] = stage1[0] ^ stage1[1];
assign stage2[1] = stage1[2] ^ stage1[3];

// Final level of XOR to compute the parity bit
assign parity = stage2[0] ^ stage2[1];

endmodule