// Define individual gate modules for modularity and potential reuse
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

// TopModule utilizing the defined gate modules for modularity
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

    // Instantiate gate modules for each output
    ANDGate      and_gate(a, b, out_and);
    ORGate       or_gate(a, b, out_or);
    XORGate      xor_gate(a, b, out_xor);
    NANDGate     nand_gate(a, b, out_nand);
    NORGate      nor_gate(a, b, out_nor);
    XNORGate     xnor_gate(a, b, out_xnor);
    ANDNOTGate   andnot_gate(a, b, out_anotb);

endmodule