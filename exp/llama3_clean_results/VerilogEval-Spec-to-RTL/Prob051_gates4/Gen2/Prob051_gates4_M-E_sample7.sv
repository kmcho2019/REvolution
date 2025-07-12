module TwoInputAND(
    input  a,
    input  b,
    output out
);
    assign out = a & b;
endmodule

module TwoInputOR(
    input  a,
    input  b,
    output out
);
    assign out = a | b;
endmodule

module TwoInputXOR(
    input  a,
    input  b,
    output out
);
    assign out = a ^ b;
endmodule

module FourInputAND(
    input  [3:0] in,
    output out
);
    wire and1, and2;
    TwoInputAND andGate1(in[3], in[2], and1);
    TwoInputAND andGate2(and1, in[1], and2);
    TwoInputAND andGate3(and2, in[0], out);
endmodule

module FourInputOR(
    input  [3:0] in,
    output out
);
    wire or1, or2;
    TwoInputOR orGate1(in[3], in[2], or1);
    TwoInputOR orGate2(in[1], in[0], or2);
    TwoInputOR orGate3(or1, or2, out);
endmodule

module FourInputXOR(
    input  [3:0] in,
    output out
);
    wire xor1, xor2;
    TwoInputXOR xorGate1(in[3], in[2], xor1);
    TwoInputXOR xorGate2(in[1], in[0], xor2);
    TwoInputXOR xorGate3(xor1, xor2, out);
endmodule

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