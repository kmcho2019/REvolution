module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, for better readability and generalization for different widths:
// assign out = in[7:0];

// However, the most straightforward and efficient way considering the given constraints:
assign out = in[7:0];

endmodule