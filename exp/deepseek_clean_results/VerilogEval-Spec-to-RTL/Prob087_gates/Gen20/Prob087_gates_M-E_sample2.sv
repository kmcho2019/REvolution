module TopModule (
    input  a,
    input  b,
    output out_and,
    output out_or,
    output out_xor,
    output out_nand,
    output out_nor,
    output out_xnor,
    output out_anotb
);

    // Instantiate primitive gates for basic operations
    and  AND_GATE(out_and, a, b);
    or   OR_GATE(out_or, a, b);
    xor  XOR_GATE(out_xor, a, b);

    // Derived gates using inversion
    not  NAND_GATE(out_nand, out_and);
    not  NOR_GATE(out_nor, out_or);
    not  XNOR_GATE(out_xnor, out_xor);

    // AND-NOT implementation
    wire not_b;
    not NOTB_GATE(not_b, b);
    and ANDNOT_GATE(out_anotb, a, not_b);

endmodule