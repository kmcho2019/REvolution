// Fundamental 2-input gate modules: AND, OR, XOR, AND_NOT

module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module OrGate(input wire a, input wire b, output wire out);
    assign out = a | b;
endmodule

module XorGate(input wire a, input wire b, output wire out);
    assign out = a ^ b;
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule

// TopModule: instantiate fundamental gates and generate complemented outputs by inversion
module TopModule(
    input wire a,
    input wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    wire and_wire, or_wire, xor_wire;

    // Instantiate fundamental gates
    AndGate and_gate_inst (.a(a), .b(b), .out(and_wire));
    OrGate  or_gate_inst  (.a(a), .b(b), .out(or_wire));
    XorGate xor_gate_inst (.a(a), .b(b), .out(xor_wire));
    AndNotGate andnot_inst(.a(a), .b(b), .out(out_anotb));

    // Assign outputs from instantiated gates and complemented outputs by inversion
    assign out_and  = and_wire;
    assign out_or   = or_wire;
    assign out_xor  = xor_wire;
    assign out_nand = ~and_wire;
    assign out_nor  = ~or_wire;
    assign out_xnor = ~xor_wire;

endmodule