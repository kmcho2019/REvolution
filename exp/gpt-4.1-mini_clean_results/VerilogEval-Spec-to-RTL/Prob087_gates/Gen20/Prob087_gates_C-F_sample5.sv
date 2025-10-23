// Essential gate modules for reuse and clarity

module AndGate(input wire a, input wire b, output wire out);
    assign out = a & b;
endmodule

module AndNotGate(input wire a, input wire b, output wire out);
    assign out = a & (~b);
endmodule

// TopModule: instantiate essential modules, use direct assigns for other outputs

module TopModule(
    input  wire a,
    input  wire b,
    output wire out_and,
    output wire out_or,
    output wire out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output wire out_anotb
);

    wire and_wire;

    // Instantiate reusable essential gates
    AndGate    and_gate_inst    (.a(a), .b(b), .out(and_wire));
    AndNotGate andnot_gate_inst (.a(a), .b(b), .out(out_anotb));

    // Direct continuous assignments for outputs using efficient expressions
    assign out_and  = and_wire;
    assign out_or   = a | b;
    assign out_xor  = a ^ b;
    assign out_nand = ~and_wire;
    assign out_nor  = ~(a | b);
    assign out_xnor = ~(a ^ b);

endmodule