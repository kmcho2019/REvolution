// Implement the 4-input AND gate
module AndGate(
    input  [3:0] in,
    output out
);
    assign out = in[3] & in[2] & in[1] & in[0];
endmodule

// Implement the 4-input OR gate
module OrGate(
    input  [3:0] in,
    output out
);
    assign out = in[3] | in[2] | in[1] | in[0];
endmodule

// Implement the 4-input XOR gate
module XorGate(
    input  [3:0] in,
    output out
);
    assign out = in[3] ^ in[2] ^ in[1] ^ in[0];
endmodule

// Top-level module instantiating the gates
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    AndGate and_gate(.in(in), .out(out_and));
    OrGate or_gate(.in(in), .out(out_or));
    XorGate xor_gate(.in(in), .out(out_xor));
endmodule