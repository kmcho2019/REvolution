module TwoNandAnd (
    input  wire a,
    input  wire b,
    output wire y
);
    wire nand_ab;
    // First NAND gate: nand_ab = ~(a & b)
    nand nand1 (nand_ab, a, b);
    // Second NAND gate: y = ~(nand_ab & nand_ab) = nand_ab (inverted) = a & b
    nand nand2 (y, nand_ab, nand_ab);
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate the structural TwoNandAnd gate to produce output q
    TwoNandAnd and_struct_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule