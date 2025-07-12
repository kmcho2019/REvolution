module nand_gate(
    input a,
    input b,
    output y
);
    assign y = ~(a & b);
endmodule

module TopModule(
    input a,
    input b,
    output out
);
    wire nand_ab;
    wire nand_a_a;
    wire nand_b_b;
    wire nand_nand_a_b;

    nand_gate u_nand_ab (
        .a(a),
        .b(b),
        .y(nand_ab)
    );

    nand_gate u_nand_a_a (
        .a(a),
        .b(a),
        .y(nand_a_a)
    );

    nand_gate u_nand_b_b (
        .a(b),
        .b(b),
        .y(nand_b_b)
    );

    nand_gate u_nand_nand_a_b (
        .a(nand_a_a),
        .b(nand_b_b),
        .y(nand_nand_a_b)
    );

    nand_gate u_final (
        .a(nand_ab),
        .b(nand_nand_a_b),
        .y(out)
    );
endmodule