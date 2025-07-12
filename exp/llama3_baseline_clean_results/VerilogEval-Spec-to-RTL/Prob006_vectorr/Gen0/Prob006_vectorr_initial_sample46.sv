module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out[7:0] = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, a more concise way using bit reversal:
// assign out = in[7:0];

// Or using a loop in a procedural block, but the above assign statement is preferred for its conciseness and clarity.

endmodule