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
    wire nand1;
    wire nand2;
    wire nand3;

    nand_gate u_nand1 (
        .a(a),
        .b(b),
        .y(nand1)
    );

    nand_gate u_nand2 (
        .a(a),
        .b(nand1),
        .y(nand2)
    );

    nand_gate u_nand3 (
        .a(b),
        .b(nand1),
        .y(nand3)
    );

    nand_gate u_out (
        .a(nand2),
        .b(nand3),
        .y(out)
    );
endmodule