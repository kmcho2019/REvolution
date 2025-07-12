module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire term0, term2_0, term2_1, term2_2, term2_3, term2_4, term2_5, term4;

// term0: all zeros
assign term0 = (~a) & (~b) & (~c) & (~d);

// term2_x: exactly two inputs are 1
assign term2_0 = a & b & (~c) & (~d);
assign term2_1 = a & (~b) & c & (~d);
assign term2_2 = a & (~b) & (~c) & d;
assign term2_3 = (~a) & b & c & (~d);
assign term2_4 = (~a) & b & (~c) & d;
assign term2_5 = (~a) & (~b) & c & d;

// term4: all ones
assign term4 = a & b & c & d;

// q is the OR of all terms with even number of ones
assign q = term0 | term2_0 | term2_1 | term2_2 | term2_3 | term2_4 | term2_5 | term4;

endmodule