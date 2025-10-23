module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Output is 1 except when a=0, b=0, c=0
    // Implemented as out = ~(~a & ~b & ~c)
    assign out = ~(~a & ~b & ~c);

endmodule