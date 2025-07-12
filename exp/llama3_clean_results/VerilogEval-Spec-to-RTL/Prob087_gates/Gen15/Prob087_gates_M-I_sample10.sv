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
    assign out_and = a & b; // Using bitwise AND for consistency
    assign out_or = a | b;  // Using bitwise OR for consistency
    assign out_xor = a ^ b; // XOR operation
    assign out_nand = ~(a & b); // NAND operation
    assign out_nor = ~(a | b);  // NOR operation
    assign out_xnor = ~(a ^ b); // XNOR operation
    assign out_anotb = a & ~b;  // AND-NOT operation

endmodule