// Refactored TopModule with direct logical operator implementation
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

    // Directly implementing logic gates using assign statements
    assign out_and = a && b;       // AND gate
    assign out_or = a || b;        // OR gate
    assign out_xor = a ^ b;        // XOR gate
    assign out_nand = ~(a && b);   // NAND gate
    assign out_nor = ~(a || b);    // NOR gate
    assign out_xnor = ~(a ^ b);    // XNOR gate
    assign out_anotb = a && ~b;    // AND with NOT gate

endmodule