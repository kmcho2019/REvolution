module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Create a wire for the negation of sel
wire not_sel;
assign not_sel = ~sel;

// Use two AND gates to conditionally pass a or b based on sel
wire and_a, and_b;
assign and_a = a & not_sel;
assign and_b = b & sel;

// Use an OR gate to combine the results of the AND gates
assign out = and_a | and_b;

endmodule