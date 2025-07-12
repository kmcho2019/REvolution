module TopModule (
    input  a,
    input  b,
    input  sel,
    output out
);

assign out = (a & ~sel) | (b & sel);

endmodule