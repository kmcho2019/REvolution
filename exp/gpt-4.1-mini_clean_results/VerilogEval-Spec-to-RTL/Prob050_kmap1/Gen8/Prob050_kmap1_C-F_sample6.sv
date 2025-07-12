module TopModule (
    input  a,
    input  b,
    input  c,
    output out
);

    // The output corresponds to the Karnaugh map:
    // out = 1 for all inputs except when a=0, b=0, c=0
    // This simplifies to the logical OR of all inputs.
    assign out = a | b | c;

endmodule