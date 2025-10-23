module TopModule (
    input a,
    input b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Basic gates using primitive instantiations
    and and_gate(out_and, a, b);
    or or_gate(out_or, a, b);
    xor xor_gate(out_xor, a, b);

    // Complemented gates using primitive instantiations
    nand nand_gate(out_nand, a, b);
    nor nor_gate(out_nor, a, b);
    xnor xnor_gate(out_xnor, a, b);

    // Special AND-NOT operation
    and anotb_gate(out_anotb, a, ~b);

endmodule