module TopModule (
    input [3:0] in,
    output [1:0] pos
);

// Directly compute output bits using nested conditionals
assign pos[1] = in[3] | (in[2] & ~(|in[1:0]));
assign pos[0] = in[3] | (in[1] & ~in[0]);

endmodule