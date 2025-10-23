module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = (b == 1 && (c == 0 || (c == 1 && (a == 0 || a == 1)));

endmodule