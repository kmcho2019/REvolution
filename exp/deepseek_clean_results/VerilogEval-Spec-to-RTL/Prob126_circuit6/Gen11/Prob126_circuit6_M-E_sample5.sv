module TopModule (
    input [2:0] a,
    output [15:0] q
);

// Each output bit is computed as a unique function of the input bits
assign q[0] = ~a[2] & a[1] & ~a[0];  // 010
assign q[1] = a[2] & ~a[1] & a[0];    // 101
assign q[2] = a[2] ^ a[1] ^ a[0];     // XOR all
assign q[3] = a[2] | (a[1] & a[0]);   // 2 OR (1 AND 0)
assign q[4] = ~a[2] & (a[1] | a[0]);  // NOT 2 AND (1 OR 0)
assign q[5] = a[2] & ~(a[1] ^ a[0]);  // 2 AND NOT (1 XOR 0)
assign q[6] = (a[2] & a[1]) | (a[1] & a[0]); // (2 AND 1) OR (1 AND 0)
assign q[7] = a[2] ^ (a[1] | a[0]);   // 2 XOR (1 OR 0)
assign q[8] = ~(a[2] | a[1] | a[0]);  // NOR all
assign q[9] = (a[2] & a[1]) ^ a[0];   // (2 AND 1) XOR 0
assign q[10] = a[2] | ~(a[1] & a[0]); // 2 OR NOT (1 AND 0)
assign q[11] = ~a[2] & (a[1] ^ a[0]); // NOT 2 AND (1 XOR 0)
assign q[12] = (a[2] ^ a[1]) & a[0];  // (2 XOR 1) AND 0
assign q[13] = a[2] & a[1] & a[0];    // AND all
assign q[14] = ~(a[2] ^ a[1] ^ a[0]); // XNOR all
assign q[15] = a[2] & (a[1] | ~a[0]); // 2 AND (1 OR NOT 0)

endmodule