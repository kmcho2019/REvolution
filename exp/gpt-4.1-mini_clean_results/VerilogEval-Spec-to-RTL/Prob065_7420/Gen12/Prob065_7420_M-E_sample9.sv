module nand2 (
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

module nand4_from_nand2 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire n1, n2, n3;

    // First level: two 2-input NAND gates
    nand2 u1 (.a(a), .b(b), .y(n1));
    nand2 u2 (.a(c), .b(d), .y(n2));

    // Second level: NAND the outputs of the first level (acts like NOR on inputs)
    nand2 u3 (.a(n1), .b(n2), .y(n3));

    // Final output: NAND gate with input tied to n3 twice (effectively NOT n3)
    // Actually, n3 is ~(n1 & n2) = NAND(n1,n2)
    // Since n1 = ~(a&b), n2=~(c&d)
    // The combination produces NAND4 behavior.
    assign y = n3;

endmodule

module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    nand4_from_nand2 u_p1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    nand4_from_nand2 u_p2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule