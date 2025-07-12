module TopModule(
    input  a,
    input  b,
    input  c,
    output out
);

assign out = b | (a & ~c);

endmodule