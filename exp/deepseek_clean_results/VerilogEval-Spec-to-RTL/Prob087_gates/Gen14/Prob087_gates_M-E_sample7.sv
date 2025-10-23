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

    // Vectorized implementation - all operations computed in parallel
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = {
        a & b,      // AND
        a | b,      // OR
        a ^ b,      // XOR
        ~(a & b),   // NAND
        ~(a | b),   // NOR
        ~(a ^ b),   // XNOR
        a & ~b      // A AND-NOT B
    };

endmodule