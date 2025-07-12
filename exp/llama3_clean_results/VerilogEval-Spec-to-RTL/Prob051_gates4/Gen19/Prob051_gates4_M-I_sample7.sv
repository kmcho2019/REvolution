// Directly implement 4-input AND, OR, and XOR gates for area and potentially power reduction
module FourInputAND(
    input  [3:0] in,
    output out
);
    assign out = in[3] & in[2] & in[1] & in[0];
endmodule

module FourInputOR(
    input  [3:0] in,
    output out
);
    assign out = in[3] | in[2] | in[1] | in[0];
endmodule

module FourInputXOR(
    input  [3:0] in,
    output out
);
    assign out = in[3] ^ in[2] ^ in[1] ^ in[0];
endmodule

// Top-level module remains the same but now uses the optimized gate modules
module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    FourInputAND andGate(in, out_and);
    FourInputOR orGate(in, out_or);
    FourInputXOR xorGate(in, out_xor);
endmodule