module TopModule (
    input  a, b,
    output out_and, out_or, out_xor,
    output out_nand, out_nor, out_xnor,
    output out_anotb
);

    // Shared intermediate signals
    wire and_out = a & b;
    wire or_out = a | b;
    wire xor_out = a ^ b;
    
    // Output assignments using shared signals
    assign out_and = and_out;
    assign out_or = or_out;
    assign out_xor = xor_out;
    assign out_nand = ~and_out;
    assign out_nor = ~or_out;
    assign out_xnor = ~xor_out;
    assign out_anotb = a & ~b;

endmodule