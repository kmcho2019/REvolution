// Define the interface or base module for gates
module Gate(
    input [3:0] in,
    output out
);

endmodule

// Implement the 4-input AND gate using bitwise AND operation
module FourInputAND(
    input  [3:0] in,
    output out
);
    assign out = &in;
endmodule

// Implement the 4-input OR gate using bitwise OR operation
module FourInputOR(
    input  [3:0] in,
    output out
);
    assign out = |in;
endmodule

// Implement the 4-input XOR gate using bitwise XOR operation
module FourInputXOR(
    input  [3:0] in,
    output out
);
    assign out = ^in;
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