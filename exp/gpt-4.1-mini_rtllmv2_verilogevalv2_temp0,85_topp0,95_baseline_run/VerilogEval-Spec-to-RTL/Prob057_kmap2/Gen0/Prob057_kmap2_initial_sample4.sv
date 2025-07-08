module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire term1, term2, term3, term4;

assign term1 = (~c) & (~d) & ((~a) | (~b)); // c'd'(a'+b')
assign term2 = (~c) & d & (~b);              // c'd b'
assign term3 = c & d & (a | b);               // cd (a + b)
assign term4 = c & (~d) & (~a);               // cd' a'

assign out = term1 | term2 | term3 | term4;

endmodule