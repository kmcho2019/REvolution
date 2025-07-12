module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Variables for complemented inputs
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // From the Karnaugh map, the minimized sum of products is:
    // out = (~d & ~a) | (~c & ~b) | (c & d & (a | b))
    // This matches the original logic but is coded directly with bitwise logic.

    assign out = (nd & na) | (nc & nb) | (c & d & (a | b));
endmodule