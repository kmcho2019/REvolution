// Define individual gate modules using logical operators
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

// TopModule instantiates the gate modules
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

    // Directly implementing the logic within the TopModule to reduce overhead
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