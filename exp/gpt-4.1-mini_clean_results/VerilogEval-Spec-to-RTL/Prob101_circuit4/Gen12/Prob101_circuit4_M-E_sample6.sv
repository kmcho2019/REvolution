module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);
    wire nb, nc;
    // Invert inputs b and c
    assign nb = ~b;
    assign nc = ~c;
    // NAND of nb and nc is equivalent to OR of b and c
    assign q = ~(nb & nc);
endmodule