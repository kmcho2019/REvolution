// Define individual gate modules using logical operators
module ANDGate(input logic a, input logic b, output logic out);
    assign out = a && b; // Using logical AND operator
endmodule

module ORGate(input logic a, input logic b, output logic out);
    assign out = a || b; // Using logical OR operator
endmodule

module XORGate(input logic a, input logic b, output logic out);
    assign out = a ^ b; // Using bitwise XOR operator
endmodule

module NANDGate(input logic a, input logic b, output logic out);
    assign out = ~(a && b); // Using logical NAND operator
endmodule

module NORGate(input logic a, input logic b, output logic out);
    assign out = ~(a || b); // Using logical NOR operator
endmodule

module XNORGate(input logic a, input logic b, output logic out);
    assign out = ~(a ^ b); // Using logical XNOR operator
endmodule

module ANDNOTGate(input logic a, input logic b, output logic out);
    assign out = a && ~b; // Using logical AND with NOT operator
endmodule

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
    assign out_and = a && b;
    assign out_or = a || b;
    assign out_xor = a ^ b;
    assign out_nand = ~(a && b);
    assign out_nor = ~(a || b);
    assign out_xnor = ~(a ^ b);
    assign out_anotb = a && ~b;

    // Although we directly implement the logic, we can still instantiate the gate modules for modularity and reusability
    ANDGate and_gate(a, b, out_and);
    ORGate or_gate(a, b, out_or);
    XORGate xor_gate(a, b, out_xor);
    NANDGate nand_gate(a, b, out_nand);
    NORGate nor_gate(a, b, out_nor);
    XNORGate xnor_gate(a, b, out_xnor);
    ANDNOTGate andnot_gate(a, b, out_anotb);

endmodule