module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire a_is_zero_and_b_is_zero_and_c_is_one;
assign a_is_zero_and_b_is_zero_and_c_is_one = (!a) && (!b) && c;

assign out = a ? 1'b1 : a_is_zero_and_b_is_zero_and_c_is_one;

endmodule