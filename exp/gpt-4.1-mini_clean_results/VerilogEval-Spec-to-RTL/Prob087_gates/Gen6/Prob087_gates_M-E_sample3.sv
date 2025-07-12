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

    // AND gate for out_and
    and u_and(out_and, a, b);

    // OR gate for out_or
    or u_or(out_or, a, b);

    // XOR gate for out_xor
    xor u_xor(out_xor, a, b);

    // NAND gate for out_nand
    nand u_nand(out_nand, a, b);

    // NOR gate for out_nor
    nor u_nor(out_nor, a, b);

    // XNOR gate for out_xnor
    xnor u_xnor(out_xnor, a, b);

    // out_anotb = a AND (NOT b)
    wire nb;
    not u_not(nb, b);
    and u_andnotb(out_anotb, a, nb);

endmodule