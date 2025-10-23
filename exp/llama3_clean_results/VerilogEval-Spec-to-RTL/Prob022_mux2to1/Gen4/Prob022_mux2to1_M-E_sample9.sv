module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

// Using AND, OR, and NOT gates to implement the 2-to-1 multiplexer
wire not_sel;
assign not_sel = ~sel;

wire and_a;
assign and_a = a & not_sel;

wire and_b;
assign and_b = b & sel;

assign out = and_a | and_b;

endmodule