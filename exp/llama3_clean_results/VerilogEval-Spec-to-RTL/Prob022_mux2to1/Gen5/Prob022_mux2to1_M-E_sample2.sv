module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire sel_not;
assign sel_not = ~sel;

assign out = (a & sel_not) | (b & sel);

endmodule