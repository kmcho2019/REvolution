module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, a more concise way to reverse the bits is:
// assign out = in[7:0];

// However, to explicitly reverse the bits as described in the thought:
// assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};
// The above two lines are equivalent but the first one explicitly shows bit reversal.

endmodule