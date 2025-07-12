module TopModule(
    input  a,
    input  b,
    input  sel,
    output wire out
);

assign out = (a & ~sel) | (b & sel);

endmodule