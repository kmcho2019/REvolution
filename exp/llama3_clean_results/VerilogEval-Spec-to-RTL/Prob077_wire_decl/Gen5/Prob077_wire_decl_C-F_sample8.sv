module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Explicitly declare intermediate wires for clarity and potential optimization
wire and_out1, and_out2;

// Assign the outputs of the AND gates to the intermediate wires
assign and_out1 = a & b;
assign and_out2 = c & d;

// Use the intermediate wires to drive the OR gate and the output
assign out = and_out1 | and_out2;

// Invert the output to generate the negated output
assign out_n = ~out;

endmodule