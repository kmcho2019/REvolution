// Improved version focusing on direct implementation and synthesis tool optimization
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

    // Direct implementation for efficiency and synthesis optimization
    assign out_and = a & b;  // Using bitwise AND for potential synthesis optimization
    assign out_or = a | b;   // Using bitwise OR for potential synthesis optimization
    assign out_xor = a ^ b;  // XOR is already efficiently implemented
    assign out_nand = ~(a & b);  // Using bitwise AND and negation for NAND
    assign out_nor = ~(a | b);   // Using bitwise OR and negation for NOR
    assign out_xnor = ~(a ^ b);  // XNOR implemented as XOR with negation
    assign out_anotb = a & ~b;   // AND-NOT implemented directly

endmodule