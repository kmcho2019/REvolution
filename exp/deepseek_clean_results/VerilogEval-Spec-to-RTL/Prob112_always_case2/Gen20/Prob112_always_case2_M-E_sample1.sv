module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Parallel detection of first '1' at each position
wire pos3_valid = in[3] & ~(|in[2:0]);
wire pos2_valid = in[2] & ~(|in[1:0]);
wire pos1_valid = in[1] & ~in[0];
wire pos0_valid = in[0];

// Binary encoding of detected positions
assign pos[1] = pos3_valid | pos2_valid;
assign pos[0] = pos3_valid | pos1_valid;

endmodule