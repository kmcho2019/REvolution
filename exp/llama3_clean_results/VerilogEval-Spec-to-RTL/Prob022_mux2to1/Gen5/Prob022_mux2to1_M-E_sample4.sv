module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire not_sel;
wire and_a;
wire and_b;

assign not_sel = ~sel;
assign and_a = a & not_sel;
assign and_b = b & sel;
assign out = and_a | and_b;

endmodule