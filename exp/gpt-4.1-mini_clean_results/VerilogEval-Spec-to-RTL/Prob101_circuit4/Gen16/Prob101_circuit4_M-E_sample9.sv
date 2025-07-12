module NAND2 (
    input x,
    input y,
    output z
);
    assign z = ~(x & y);
endmodule

module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);
    wire nand_bc;
    wire nand_nand;

    NAND2 nand1 (
        .x(b),
        .y(c),
        .z(nand_bc)
    );

    // Double NAND to implement OR
    NAND2 nand2 (
        .x(nand_bc),
        .y(nand_bc),
        .z(q)
    );
endmodule