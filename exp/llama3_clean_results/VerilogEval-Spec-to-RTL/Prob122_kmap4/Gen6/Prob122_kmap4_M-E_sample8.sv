module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire eq_ab; // equality of a and b
wire neq_ab; // inequality of a and b

assign eq_ab = ~(a ^ b); // a and b are equal
assign neq_ab = a ^ b; // a and b are not equal

assign out = (c == d) ? eq_ab : neq_ab;

endmodule