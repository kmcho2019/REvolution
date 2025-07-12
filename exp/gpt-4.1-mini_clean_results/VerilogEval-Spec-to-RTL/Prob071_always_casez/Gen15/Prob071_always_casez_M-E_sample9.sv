module TopModule(
    input  [7:0] in,
    output [2:0] pos
);

// Generate mask of bits that have no lower set bit
wire [7:0] masked;
assign masked[0] = in[0];
assign masked[1] = in[1] & ~in[0];
assign masked[2] = in[2] & ~(in[1] | in[0]);
assign masked[3] = in[3] & ~(in[2] | in[1] | in[0]);
assign masked[4] = in[4] & ~(in[3] | in[2] | in[1] | in[0]);
assign masked[5] = in[5] & ~(in[4] | in[3] | in[2] | in[1] | in[0]);
assign masked[6] = in[6] & ~(in[5] | in[4] | in[3] | in[2] | in[1] | in[0]);
assign masked[7] = in[7] & ~(in[6] | in[5] | in[4] | in[3] | in[2] | in[1] | in[0]);

// Encode the one-hot masked vector to binary
assign pos =
    masked[0] ? 3'd0 :
    masked[1] ? 3'd1 :
    masked[2] ? 3'd2 :
    masked[3] ? 3'd3 :
    masked[4] ? 3'd4 :
    masked[5] ? 3'd5 :
    masked[6] ? 3'd6 :
    masked[7] ? 3'd7 :
    3'd0; // default zero if no bits set

endmodule