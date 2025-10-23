module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire sel_bar; // Complement of sel
wire and_a;  // a gated by sel_bar
wire and_b;  // b gated by sel

// Calculate the complement of sel
assign sel_bar = ~sel;

// Gate inputs with sel and sel_bar
assign and_a = a & sel_bar;
assign and_b = b & sel;

// OR the gated inputs to get the final output
assign out = and_a | and_b;

endmodule