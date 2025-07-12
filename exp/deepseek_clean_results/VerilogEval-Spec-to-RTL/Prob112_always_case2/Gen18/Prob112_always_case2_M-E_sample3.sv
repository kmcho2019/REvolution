module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Generate masked version where only first '1' and following '0's remain
wire [3:0] masked_in;
assign masked_in[0] = in[0];
assign masked_in[1] = in[1] & ~in[0];
assign masked_in[2] = in[2] & ~(|in[1:0]);
assign masked_in[3] = in[3] & ~(|in[2:0]);

// Direct binary encoding from masked pattern
assign pos[1] = masked_in[2] | masked_in[3];
assign pos[0] = masked_in[1] | masked_in[3];

endmodule