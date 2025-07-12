// Implement the 2-input AND gate
module TwoInputAND(
    input  a,
    input  b,
    output out
);
    assign out = a & b;
endmodule

// Implement the 2-input OR gate
module TwoInputOR(
    input  a,
    input  b,
    output out
);
    assign out = a | b;
endmodule

// Implement the 2-input XOR gate
module TwoInputXOR(
    input  a,
    input  b,
    output out
);
    assign out = a ^ b;
endmodule

// Implement the 2-input XNOR gate
module TwoInputXNOR(
    input  a,
    input  b,
    output out
);
    assign out = ~(a ^ b);
endmodule

// Implement the 4-input AND gate using 2-input AND gates
module FourInputAND(
    input  [3:0] in,
    output out
);
    TwoInputAND andGate1(in[3], in[2], out);
    TwoInputAND andGate2(in[1], in[0], out);
    assign out = andGate1.out & andGate2.out;
endmodule

// Implement the 4-input OR gate using 2-input OR gates
module FourInputOR(
    input  [3:0] in,
    output out
);
    TwoInputOR orGate1(in[3], in[2], out);
    TwoInputOR orGate2(in[1], in[0], out);
    assign out = orGate1.out | orGate2.out;
endmodule

// Optimized 4-input XOR gate
module FourInputXOR(
    input  [3:0] in,
    output out
);
    TwoInputXOR xorGate1(in[3], in[2], out);
    TwoInputXOR xorGate2(in[1], in[0], out);
    assign out = xorGate1.out ^ xorGate2.out;
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