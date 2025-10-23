module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

// Intermediate wires to represent the outputs of the AND gates
wire and_out_1;
wire and_out_2;

// Assign statements for the AND gates
assign and_out_1 = a & b;
assign and_out_2 = c & d;

// Assign statement for the OR gate
assign out = and_out_1 | and_out_2;

// Use a separate assign statement for out_n to maintain clarity and readability
assign out_n = ~out;

endmodule