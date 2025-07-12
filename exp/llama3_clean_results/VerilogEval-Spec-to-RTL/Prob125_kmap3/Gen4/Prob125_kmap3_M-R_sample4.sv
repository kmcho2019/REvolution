module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

assign out = a || (!c && !a) || (c && !b && !a);

endmodule