module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire nb, nc, nand_out;
    // Invert b and c
    assign nb = ~b;
    assign nc = ~c;
    // NAND of inverted b and c (equivalent to OR)
    assign nand_out = ~(nb & nc);
    assign q = nand_out;
endmodule