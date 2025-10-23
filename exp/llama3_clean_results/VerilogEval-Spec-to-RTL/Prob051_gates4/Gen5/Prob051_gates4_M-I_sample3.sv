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

// Implement the 4-input AND gate using 2-input AND gates
module FourInputAND(
    input  [3:0] in,
    output out
);
    assign out = in[3] & in[2] & in[1] & in[0];
endmodule

// Implement the 4-input OR gate using a single OR operation
module FourInputOR(
    input  [3:0] in,
    output out
);
    assign out = in[3] | in[2] | in[1] | in[0];
endmodule

// Implement the 4-input XOR gate using a single XOR operation
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