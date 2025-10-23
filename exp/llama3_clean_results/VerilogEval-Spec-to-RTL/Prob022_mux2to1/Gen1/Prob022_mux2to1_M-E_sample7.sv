module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire not_sel;
assign not_sel = ~sel;
assign out = (a & not_sel) | (b & sel);

endmodule