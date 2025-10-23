module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// pos[1] is 1 if there's a 1 in bits 3 or 2
assign pos[1] = |in[3:2];

// pos[0] is 1 if:
//   - bit 3 is 1 OR
//   - bit 1 is 1 AND neither bit 3 nor 2 is 1
assign pos[0] = in[3] | (in[1] & ~(|in[3:2]));

endmodule