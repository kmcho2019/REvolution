module AndGate (
    input  wire a,
    input  wire b,
    output wire y
);
    wire nand_ab;
    wire not_nand_ab;

    // NAND gate implements ~(a & b)
    nand u1(nand_ab, a, b);
    // NAND gate with tied inputs acts as inverter: y = nand_ab'
    nand u2(not_nand_ab, nand_ab, nand_ab);

    assign y = not_nand_ab;
endmodule

module TopModule (
    input  wire a,
    input  wire b,
    output wire q
);
    // Instantiate the AndGate module
    AndGate and_inst (
        .a(a),
        .b(b),
        .y(q)
    );
endmodule