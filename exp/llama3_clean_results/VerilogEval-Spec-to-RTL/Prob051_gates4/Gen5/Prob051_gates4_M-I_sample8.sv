// Implement the AND gate (no change)
module AndGate(
    input [3:0] in,
    output out
);
    assign out = &in;
endmodule

// Implement the OR gate (no change)
module OrGate(
    input [3:0] in,
    output out
);
    assign out = |in;
endmodule

// Implement the XOR gate using a tree-like structure of 2-input XOR gates
module XorGate(
    input [3:0] in,
    output out
);
    wire xor_0_1;
    wire xor_2_3;
    assign xor_0_1 = in[0] ^ in[1];
    assign xor_2_3 = in[2] ^ in[3];
    assign out = xor_0_1 ^ xor_2_3;
endmodule

// Top-level module (no change)
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