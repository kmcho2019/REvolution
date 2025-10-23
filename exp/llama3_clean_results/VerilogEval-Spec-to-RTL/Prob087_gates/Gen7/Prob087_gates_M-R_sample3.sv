// TopModule directly implements the logic for efficiency
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

    // Directly implementing the logic within TopModule for efficiency
    assign out_and = a & b;  // Bitwise AND operation
    assign out_or = a | b;   // Bitwise OR operation
    assign out_xor = a ^ b;  // Bitwise XOR operation
    assign out_nand = ~(a & b);  // Bitwise NAND operation
    assign out_nor = ~(a | b);   // Bitwise NOR operation
    assign out_xnor = ~(a ^ b);  // Bitwise XNOR operation
    assign out_anotb = a & ~b;   // AND operation with NOT b

endmodule