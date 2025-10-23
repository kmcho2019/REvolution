module TopModule(
    input  a,
    input  b,
    input  c,
    output wire out
);

wire not_a, not_b, not_c;
wire zero_condition;

// Invert inputs
assign not_a = ~a;
assign not_b = ~b;
assign not_c = ~c;

// Detect zero condition when all inputs are zero
assign zero_condition = not_a & not_b & not_c;

// Output is the negation of zero_condition
assign out = ~zero_condition;

endmodule