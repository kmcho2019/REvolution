// Define individual gate modules for potential future use or modularity
module ANDGate(input a, input b, output out);
    assign out = a && b;
endmodule

module ORGate(input a, input b, output out);
    assign out = a || b;
endmodule

module XORGate(input a, input b, output out);
    assign out = a ^ b;
endmodule

module NANDGate(input a, input b, output out);
    assign out = ~(a && b);
endmodule

module NORGate(input a, input b, output out);
    assign out = ~(a || b);
endmodule

module XNORGate(input a, input b, output out);
    assign out = ~(a ^ b);
endmodule

module ANDNOTGate(input a, input b, output out);
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

    // Alternatively, we could instantiate the gate modules for modularity
    // ANDGate and_gate(a, b, out_and);
    // ORGate or_gate(a, b, out_or);
    // XORGate xor_gate(a, b, out_xor);
    // NANDGate nand_gate(a, b, out_nand);
    // NORGate nor_gate(a, b, out_nor);
    // XNORGate xnor_gate(a, b, out_xnor);
    // ANDNOTGate andnot_gate(a, b, out_anotb);

endmodule