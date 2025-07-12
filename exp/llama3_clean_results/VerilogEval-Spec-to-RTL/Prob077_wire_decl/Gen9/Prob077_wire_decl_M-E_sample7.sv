module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire [1:0] and_out;

assign and_out[0] = (a && b)? 1'b1 : 1'b0;
assign and_out[1] = (c && d)? 1'b1 : 1'b0;

assign out = (and_out[0] || and_out[1])? 1'b1 : 1'b0;
assign out_n = ~out;

endmodule