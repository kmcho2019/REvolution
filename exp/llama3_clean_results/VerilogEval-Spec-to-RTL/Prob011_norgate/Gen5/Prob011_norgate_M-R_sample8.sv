module TopModule(
    input  a,
    input  b,
    output out
);

always @(*)
    out = ~(a | b);

endmodule