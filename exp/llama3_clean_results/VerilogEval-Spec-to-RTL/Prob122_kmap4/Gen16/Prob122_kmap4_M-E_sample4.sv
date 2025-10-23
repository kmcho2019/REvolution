module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    wire minterm1, minterm2, minterm3, minterm4;

    // Implementing minterms based on the Karnaugh map
    assign minterm1 = ~a & ~b & c & ~d;
    assign minterm2 = ~a & b & ~c & ~d;
    assign minterm3 = a & ~b & ~c & d;
    assign minterm4 = a & b & c & ~d;

    // Combining minterms to produce the final output
    assign out = minterm1 | minterm2 | minterm3 | minterm4;

endmodule