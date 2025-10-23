module TopModule(
    input  [7:0] in,
    output [7:0] out
);

assign out = {in[0], in[1], in[2], in[3], in[4], in[5], in[6], in[7]};

// Alternatively, a more concise way to express this, considering the fixed size, could be using a for loop in a generate block, but for simplicity and direct synthesis, the above line suffices.

endmodule