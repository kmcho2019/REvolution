module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

wire sel_n = ~sel;

assign out = sel_n ? a : b;

endmodule