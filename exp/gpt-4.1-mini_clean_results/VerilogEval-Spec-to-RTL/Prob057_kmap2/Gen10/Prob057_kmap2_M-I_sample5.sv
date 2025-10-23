module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Inverted inputs (shared)
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Common OR term
    wire a_or_b = a | b;

    // Product terms:

    // Term1: ~c & ~d (covers all cd=00 ones)
    wire term1 = nc & nd;

    // Term2: ~b & d & ~c (only for cd=01 with b=0)
    wire term2 = nb & d & nc;

    // Term3: ~a & ~d & c (covers c=1, d=0 with a=0)
    wire term3 = na & nd & c;

    // Term4: c & d & (a | b)
    wire term4 = c & d & a_or_b;

    assign out = term1 | term2 | term3 | term4;

endmodule