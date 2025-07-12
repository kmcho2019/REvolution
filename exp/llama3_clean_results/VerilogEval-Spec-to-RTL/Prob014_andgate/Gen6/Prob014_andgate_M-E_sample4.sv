module TopModule(
    input  a,
    input  b,
    output out
);

// Define a parameter for the gate type
parameter GATE_TYPE = 0; // 0 for AND, 1 for OR, 2 for XOR, etc.

// Implement a generic logical gate using an always block
always @(*) begin
    case(GATE_TYPE)
        0: out = a & b; // AND gate
        1: out = a | b; // OR gate
        2: out = a ^ b; // XOR gate
        default: out = 1'bz; // High impedance for unknown gate type
    endcase
end

endmodule