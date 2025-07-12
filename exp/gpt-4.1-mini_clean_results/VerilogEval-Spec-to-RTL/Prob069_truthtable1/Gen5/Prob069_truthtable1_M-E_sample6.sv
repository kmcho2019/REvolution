module TopModule (
    input  x3,
    input  x2,
    input  x1,
    output f
);

wire n_x3;
wire and0_out, and1_out;

assign n_x3 = ~x3;
assign and0_out = n_x3 & x2;
assign and1_out = x3 & x1;
assign f = and0_out | and1_out;

endmodule