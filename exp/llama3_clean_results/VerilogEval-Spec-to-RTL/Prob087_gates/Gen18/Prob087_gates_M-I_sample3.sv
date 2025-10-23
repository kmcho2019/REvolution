// Define a parameterized gate module for simplification
module LogicGate(
    input  logic a,
    input  logic b,
    input  logic[2:0] op, // 3-bit opcode for different operations
    output logic out
);

    always_comb begin
        case(op)
            3'b000: out = a && b;  // AND
            3'b001: out = a || b;  // OR
            3'b010: out = a ^ b;   // XOR
            3'b011: out = ~(a && b); // NAND
            3'b100: out = ~(a || b); // NOR
            3'b101: out = ~(a ^ b);  // XNOR
            3'b110: out = a && ~b;  // AND-NOT
            default: out = 1'bx;    // Invalid operation
        endcase
    end

endmodule

// TopModule instantiates the gate module with different operations
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

    // Instantiate the LogicGate module for each operation
    LogicGate and_gate(a, b, 3'b000, out_and);
    LogicGate or_gate(a, b, 3'b001, out_or);
    LogicGate xor_gate(a, b, 3'b010, out_xor);
    LogicGate nand_gate(a, b, 3'b011, out_nand);
    LogicGate nor_gate(a, b, 3'b100, out_nor);
    LogicGate xnor_gate(a, b, 3'b101, out_xnor);
    LogicGate andnot_gate(a, b, 3'b110, out_anotb);

endmodule