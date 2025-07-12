module TopModule(
    input  a,
    input  b,
    input  sel,
    output out
);

wire sel_inv;
assign sel_inv = ~sel;
assign out = (a & sel_inv) | (b & sel);

endmodule