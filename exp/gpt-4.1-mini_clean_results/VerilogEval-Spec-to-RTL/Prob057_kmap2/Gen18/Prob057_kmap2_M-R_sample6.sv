module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Directly assign product terms without intermediate named wires
    wire term1 = (~c & ~d & ~(a & b));
    wire term2 = (c & d & (a | b));
    wire term3 = (c & ~d & ~a);
    wire term4 = (~c & d & ~b);

    // Output is OR of all product terms
    assign out = term1 | term2 | term3 | term4;

endmodule