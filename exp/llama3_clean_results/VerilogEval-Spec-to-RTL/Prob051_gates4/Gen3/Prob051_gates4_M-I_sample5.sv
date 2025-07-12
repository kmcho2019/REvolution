// Top-level module directly implementing the gates
module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);
    assign out_and = &in; // Direct implementation of 4-input AND gate
    assign out_or = |in;  // Direct implementation of 4-input OR gate
    assign out_xor = ^in; // Direct implementation of 4-input XOR gate
endmodule