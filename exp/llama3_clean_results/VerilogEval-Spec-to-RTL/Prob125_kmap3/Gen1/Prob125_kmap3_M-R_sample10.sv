module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire when_a_is_one;
assign when_a_is_one = a;

wire when_a_is_zero_and_b_is_zero_and_c_is_one;
assign when_a_is_zero_and_b_is_zero_and_c_is_one = (!a) && (!b) && c;

assign out = when_a_is_one || when_a_is_zero_and_b_is_zero_and_c_is_one;

// Alternatively, using conditional operator
// assign out = a ? 1'b1 : (!b && c);

endmodule