module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // Implement out = ~(~a & ~b & ~c) using continuous assignment
    assign out = ~(~a & ~b & ~c);

endmodule