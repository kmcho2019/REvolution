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

    // Compute common subexpressions once
    wire and_result = a & b;
    wire or_result = a | b;
    wire xor_result = a ^ b;

    // Vectorized implementation with shared subexpressions
    assign {out_and, out_or, out_xor, out_nand, out_nor, out_xnor, out_anotb} = {
        and_result,        // AND
        or_result,         // OR
        xor_result,       // XOR
        ~and_result,      // NAND (derived from AND)
        ~or_result,       // NOR (derived from OR)
        ~xor_result,     // XNOR (derived from XOR)
        a & ~b           // A AND-NOT B
    };

endmodule