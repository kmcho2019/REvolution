// Define individual gate modules using logical operators for potential future use
module ANDGate(input logic a, input logic b, output logic out);
    assign out = a && b;
endmodule

module ORGate(input logic a, input logic b, output logic out);
    assign out = a || b;
endmodule

module XORGate(input logic a, input logic b, output logic out);
    assign out = a ^ b;
endmodule

module NANDGate(input logic a, input logic b, output logic out);
    assign out = ~(a && b);
endmodule

module NORGate(input logic a, input logic b, output logic out);
    assign out = ~(a || b);
endmodule

module XNORGate(input logic a, input logic b, output logic out);
    assign out = ~(a ^ b);
endmodule

module ANDNOTGate(input logic a, input logic b, output logic out);
    assign out = a && ~b;
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

    // Alternatively, we could instantiate the gate modules, but direct implementation is more efficient
    // ANDGate and_gate(a, b, out_and);
    // ORGate or_gate(a, b, out_or);
    // XORGate xor_gate(a, b, out_xor);
    // NANDGate nand_gate(a, b, out_nand);
    // NORGate nor_gate(a, b, out_nor);
    // XNORGate xnor_gate(a, b, out_xnor);
    // ANDNOTGate andnot_gate(a, b, out_anotb);

endmodule