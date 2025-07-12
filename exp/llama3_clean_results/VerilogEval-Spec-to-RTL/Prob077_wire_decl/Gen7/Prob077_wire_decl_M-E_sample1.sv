module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Intermediate wires for the AND operations
wire and_out1, and_out2;

// Perform the AND operations
assign and_out1 = a & b;
assign and_out2 = c & d;

// Use the intermediate wires to calculate the final output
assign out = and_out1 | and_out2;

// Calculate the inverted output
assign out_n = ~out;

endmodule