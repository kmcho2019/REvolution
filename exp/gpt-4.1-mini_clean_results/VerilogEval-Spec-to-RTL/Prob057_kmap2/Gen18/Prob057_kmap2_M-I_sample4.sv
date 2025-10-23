module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    // Inverted signals for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // From Karnaugh map groups and minimal expressions:

    // Group A: cells where c=0,d=0 and a,b vary (rows cd=00)
    // K-map: 00-00: a b = 00 01 11 10: out=1 1 0 1
    // Simplify ~c & ~d & ( ~a | ~b ) covers (00,00), (01,00), (10,00)
    wire groupA = nc & nd & (na | nb);

    // Group B: cells where c=0,d=1 and b=0 (cd=01 with b=0)
    wire groupB = nc & d & nb;

    // Group C: cells where c=1,d=0 and a=0 (cd=10 with a=0)
    wire groupC = c & nd & na;

    // Group D: cells where c=1,d=1 and (a=1 or b=1)
    wire groupD = c & d & (a | b);

    // Final output is OR of all groups
    assign out = groupA | groupB | groupC | groupD;

endmodule