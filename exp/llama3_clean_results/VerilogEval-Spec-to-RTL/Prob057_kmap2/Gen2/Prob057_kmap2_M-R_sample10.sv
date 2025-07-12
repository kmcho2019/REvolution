module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

wire cond1;
wire cond2;
wire cond3;
wire cond4;

assign cond1 = (!c & !d) & (a | b);
assign cond2 = (!c & d) & (a | !b);
assign cond3 = (c & d) & (a | b);
assign cond4 = (c & !d) & (!a & !b);

assign out = cond1 | cond2 | cond3 | cond4;

endmodule