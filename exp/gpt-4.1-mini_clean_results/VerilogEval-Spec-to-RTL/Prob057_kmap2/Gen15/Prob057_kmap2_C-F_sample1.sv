module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    // Shared inverted inputs for reuse
    wire na = ~a;
    wire nb = ~b;
    wire nc = ~c;
    wire nd = ~d;

    // Group 1: covers minterms where c=0,d=0 and a=0 or b=0 
    // (corresponds roughly to (~c & ~d & (~a | ~b)))
    wire group1 = nc & nd & (na | nb);

    // Group 2: covers minterms where c=0, d=1 and b=0 (regardless of a)
    wire group2 = nc & d & nb;

    // Group 3: covers minterms where c=1, d=0 and a=0 (regardless of b)
    wire group3 = c & nd & na;

    // Group 4: covers minterms where c=1, d=1 and a=1 or b=1
    wire group4 = c & d & (a | b);

    // Output is OR of all group terms
    assign out = group1 | group2 | group3 | group4;

endmodule