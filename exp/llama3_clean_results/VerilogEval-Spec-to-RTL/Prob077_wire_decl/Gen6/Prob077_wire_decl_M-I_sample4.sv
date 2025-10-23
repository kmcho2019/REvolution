module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Intermediate wires to explicitly represent the AND operations
wire and_result1;
wire and_result2;

// Assign the AND operations to the intermediate wires
assign and_result1 = a & b;
assign and_result2 = c & d;

// The final output is the OR of the two AND results
assign out = and_result1 | and_result2;

// The inverted output
assign out_n = ~out;

endmodule