// Define individual gate modules using logical operators
module ANDGate(input logic a, input logic b, output logic out);
    assign out = a && b; // Using logical AND operator
endmodule

module ORGate(input logic a, input logic b, output logic out);
    assign out = a || b; // Using logical OR operator
endmodule

// Implement XOR and XNOR using simpler gate structures
module XORGate(input logic a, input logic b, output logic out);
    assign out = (a &&!b) || (!a && b); // Using AND, OR, and NOT operators
endmodule

module XNORGate(input logic a, input logic b, output logic out);
    assign out = (a && b) || (!a &&!b); // Using AND, OR, and NOT operators
endmodule

module NANDGate(input logic a, input logic b, output logic out);
    assign out = ~(a && b); // Using logical NAND operator
endmodule

module NORGate(input logic a, input logic b, output logic out);
    assign out = ~(a || b); // Using logical NOR operator
endmodule

module ANDNOTGate(input logic a, input logic b, output logic out);
    assign out = a && ~b; // Using logical AND with NOT operator
endmodule

// TopModule instantiates the gate modules
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

    // Instantiating individual gate modules for modularity and efficiency
    ANDGate and_gate(a, b, out_and);
    ORGate or_gate(a, b, out_or);
    XORGate xor_gate(a, b, out_xor);
    NANDGate nand_gate(a, b, out_nand);
    NORGate nor_gate(a, b, out_nor);
    XNORGate xnor_gate(a, b, out_xnor);
    ANDNOTGate andnot_gate(a, b, out_anotb);

endmodule