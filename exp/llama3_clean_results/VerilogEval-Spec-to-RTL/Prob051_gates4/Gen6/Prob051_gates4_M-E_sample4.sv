// Define a generic gate module that can perform AND, OR, or XOR
module GenericGate(
    input  a,
    input  b,
    input  [1:0] operation, // 0: AND, 1: OR, 2: XOR
    output out
);
    always @(*) begin
        case(operation)
            2'b00: out = a & b; // AND
            2'b01: out = a | b; // OR
            2'b10: out = a ^ b; // XOR
            default: out = 1'b0; // Default to 0 for unknown operation
        endcase
    end
endmodule

// Implement the 4-input AND gate using the generic gate
module FourInputAND(
    input  [3:0] in,
    output out
);
    wire and1, and2;
    GenericGate andGate1(in[3], in[2], 2'b00, and1);
    GenericGate andGate2(and1, in[1], 2'b00, and2);
    GenericGate andGate3(and2, in[0], 2'b00, out);
endmodule

// Implement the 4-input OR gate using the generic gate
module FourInputOR(
    input  [3:0] in,
    output out
);
    wire or1, or2;
    GenericGate orGate1(in[3], in[2], 2'b01, or1);
    GenericGate orGate2(in[1], in[0], 2'b01, or2);
    GenericGate orGate3(or1, or2, 2'b01, out);
endmodule

// Implement the 4-input XOR gate using the generic gate
module FourInputXOR(
    input  [3:0] in,
    output out
);
    wire xor1, xor2;
    GenericGate xorGate1(in[3], in[2], 2'b10, xor1);
    GenericGate xorGate2(in[1], in[0], 2'b10, xor2);
    GenericGate xorGate3(xor1, xor2, 2'b10, out);
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