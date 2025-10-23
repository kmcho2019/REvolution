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

    // Basic operations
    wire and_result = a & b;
    wire or_result = a | b;
    wire xor_result = a ^ b;

    // Negated operations (derived from basic operations)
    wire nand_result = ~and_result;
    wire nor_result = ~or_result;
    wire xnor_result = ~xor_result;

    // Special operation
    wire anotb_result = a & ~b;

    // Assign outputs
    assign out_and = and_result;
    assign out_or = or_result;
    assign out_xor = xor_result;
    assign out_nand = nand_result;
    assign out_nor = nor_result;
    assign out_xnor = xnor_result;
    assign out_anotb = anotb_result;

endmodule