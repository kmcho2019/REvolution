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

    // Basic binary operations using gate primitives
    and  and_gate(out_and, a, b);
    or   or_gate(out_or, a, b);
    xor  xor_gate(out_xor, a, b);

    // Complemented versions using explicit NOT gates
    not  not_and(out_nand, out_and);
    not  not_or(out_nor, out_or);
    not  not_xor(out_xnor, out_xor);

    // AND-NOT operation implemented directly
    wire not_b;
    not  not_b_gate(not_b, b);
    and  and_not_gate(out_anotb, a, not_b);

endmodule