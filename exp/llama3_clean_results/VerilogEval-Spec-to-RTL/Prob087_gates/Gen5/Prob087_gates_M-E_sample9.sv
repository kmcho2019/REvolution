// Define a generic logic gate module
module GenericGate(
    input a,
    input b,
    input [2:0] op, // Operation selector (0: AND, 1: OR, 2: XOR, 3: NAND, 4: NOR, 5: XNOR, 6: AND-NOT)
    output out
);

    always @(*) begin
        case (op)
            3'b000: out = a && b; // AND
            3'b001: out = a || b; // OR
            3'b010: out = a ^ b; // XOR
            3'b011: out = ~(a && b); // NAND
            3'b100: out = ~(a || b); // NOR
            3'b101: out = ~(a ^ b); // XNOR
            3'b110: out = a && ~b; // AND-NOT
            default: out = 1'b0; // Default to 0 for invalid operation
        endcase
    end

endmodule

// TopModule instantiates the generic gate module for each operation
module TopModule(
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

    GenericGate and_gate(a, b, 3'b000, out_and);
    GenericGate or_gate(a, b, 3'b001, out_or);
    GenericGate xor_gate(a, b, 3'b010, out_xor);
    GenericGate nand_gate(a, b, 3'b011, out_nand);
    GenericGate nor_gate(a, b, 3'b100, out_nor);
    GenericGate xnor_gate(a, b, 3'b101, out_xnor);
    GenericGate andnot_gate(a, b, 3'b110, out_anotb);

endmodule