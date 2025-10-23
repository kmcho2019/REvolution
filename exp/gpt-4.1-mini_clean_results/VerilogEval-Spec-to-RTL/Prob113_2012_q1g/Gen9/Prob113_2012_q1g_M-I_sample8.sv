module TopModule(
    input  [3:0] x,
    output       f
);

wire term0, term1;

assign term0 = ~x[3] & (~x[1] | (x[2] & x[1] & ~x[0]));
assign term1 =  x[3] & x[2] & (~x[0] | x[1]);

assign f = term0 | term1;

endmodule