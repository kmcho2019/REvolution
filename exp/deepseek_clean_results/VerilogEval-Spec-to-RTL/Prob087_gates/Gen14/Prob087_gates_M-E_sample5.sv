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

    // Pack all outputs into a vector for unified computation
    wire [6:0] ops;

    // Compute all operations in one expression
    assign ops = {
        a & ~b,     // out_anotb [6]
        ~(a ^ b),   // out_xnor  [5]
        ~(a | b),   // out_nor   [4]
        ~(a & b),   // out_nand  [3]
        a ^ b,      // out_xor   [2]
        a | b,      // out_or    [1]
        a & b       // out_and   [0]
    };

    // Unpack the vector to individual outputs
    assign {out_anotb, out_xnor, out_nor, out_nand, out_xor, out_or, out_and} = ops;

endmodule