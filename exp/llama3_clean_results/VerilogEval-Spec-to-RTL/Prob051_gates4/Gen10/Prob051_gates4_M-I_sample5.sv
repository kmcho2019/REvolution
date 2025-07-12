// Implement the 4-input AND gate directly
module FourInputAND(
    input  [3:0] in,
    output out
);
    assign out = in[3] & in[2] & in[1] & in[0];
endmodule

// Implement the 4-input OR gate directly
module FourInputOR(
    input  [3:0] in,
    output out
);
    assign out = in[3] | in[2] | in[1] | in[0];
endmodule

// Implement the 4-input XOR gate directly
module FourInputXOR(
    input  [3:0] in,
    output out
);
    assign out = in[3] ^ in[2] ^ in[1] ^ in[0];
endmodule

// Top-level module instantiating the 4-input gates
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