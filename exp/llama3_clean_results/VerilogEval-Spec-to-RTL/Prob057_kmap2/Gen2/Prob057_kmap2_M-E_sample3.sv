module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output reg out
);

always @(*)
    out = (a == d) || (b == c && a) || (b && !c);

endmodule