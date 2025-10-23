module TopModule(
    input  logic a,
    input  logic b,
    output logic out_and,
    output logic out_or,
    output logic out_xor,
    output logic out_nand,
    output logic out_nor,
    output logic out_xnor,
    output logic out_anotb
);

    // Directly implementing logic gates within TopModule
    assign out_and = a && b; // Logical AND
    assign out_or = a || b; // Logical OR
    assign out_xor = a ^ b; // Bitwise XOR
    assign out_nand = ~(a && b); // Logical NAND
    assign out_nor = ~(a || b); // Logical NOR
    assign out_xnor = ~(a ^ b); // Logical XNOR
    assign out_anotb = a && ~b; // Logical AND with NOT

endmodule