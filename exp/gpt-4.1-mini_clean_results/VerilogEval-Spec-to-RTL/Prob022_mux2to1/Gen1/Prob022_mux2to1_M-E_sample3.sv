module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

wire sel_n;

assign sel_n = ~sel;
assign out = (a & sel_n) | (b & sel);

endmodule