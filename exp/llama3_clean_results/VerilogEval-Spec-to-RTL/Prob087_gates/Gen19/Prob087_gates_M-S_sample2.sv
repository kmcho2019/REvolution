// Define individual gate modules for potential future use
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

// TopModule using the gate modules for simplicity and modularity
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

    // Instantiate the gate modules for each logical operation
    ANDGate and_module(a, b, out_and);
    ORGate or_module(a, b, out_or);
    XORGate xor_module(a, b, out_xor);
    NANDGate nand_module(a, b, out_nand);
    NORGate nor_module(a, b, out_nor);
    XNORGate xnor_module(a, b, out_xnor);
    ANDNOTGate anotb_module(a, b, out_anotb);

endmodule