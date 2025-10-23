// Define an enumeration for the different gate types
typedef enum logic [2:0] {
    AND,
    OR,
    XOR,
    NAND,
    NOR,
    XNOR,
    ANDNOT
} gate_type;

// Define the Gate Factory module
module GateFactory(
    input  logic a,
    input  logic b,
    input  gate_type op,
    output logic out
);

    // Use a case statement to instantiate the correct gate
    always_comb begin
        case (op)
            AND: out = a && b;
            OR: out = a || b;
            XOR: out = a ^ b;
            NAND: out = ~(a && b);
            NOR: out = ~(a || b);
            XNOR: out = ~(a ^ b);
            ANDNOT: out = a && ~b;
            default: out = 1'b0;
        endcase
    end

endmodule

// Define the TopModule that uses the Gate Factory
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

    // Instantiate the Gate Factory for each output
    GateFactory and_gate(a, b, AND, out_and);
    GateFactory or_gate(a, b, OR, out_or);
    GateFactory xor_gate(a, b, XOR, out_xor);
    GateFactory nand_gate(a, b, NAND, out_nand);
    GateFactory nor_gate(a, b, NOR, out_nor);
    GateFactory xnor_gate(a, b, XNOR, out_xnor);
    GateFactory andnot_gate(a, b, ANDNOT, out_anotb);

endmodule