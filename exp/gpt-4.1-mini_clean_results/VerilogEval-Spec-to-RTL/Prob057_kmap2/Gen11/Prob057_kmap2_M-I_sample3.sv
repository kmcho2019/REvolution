module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Inverted inputs
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Intermediate terms
    wire a_or_b = a | b;

    // t1 = (~d & ~a) | ~b
    wire t1 = (nd & na) | nb; // nb = ~b

    // t2 = (~d & ~a) | (d & (a | b))
    wire t2 = (nd & na) | (d & a_or_b);

    // out = (~c & t1) | (c & t2)
    assign out = (nc & t1) | (c & t2);

endmodule