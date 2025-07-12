// Implement the AND gate
module AndGate(
    input [3:0] in,
    output out
);
    assign out = &in;
endmodule

// Implement the OR gate
module OrGate(
    input [3:0] in,
    output out
);
    assign out = |in;
endmodule

// Implement the XOR gate
module XorGate(
    input [3:0] in,
    output out
);
    assign out = ^in;
endmodule

// Top-level module instantiating the specific gates
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    AndGate and_gate(.in(in), .out(out_and));
    OrGate or_gate(.in(in), .out(out_or));
    XorGate xor_gate(.in(in), .out(out_xor));
endmodule