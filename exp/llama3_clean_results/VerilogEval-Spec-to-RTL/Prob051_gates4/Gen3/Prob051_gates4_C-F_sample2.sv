// TopModule: A combinational circuit with four inputs (in[3:0]) and three outputs:
// - out_and: Output of a 4-input AND gate
// - out_or: Output of a 4-input OR gate
// - out_xor: Output of a 4-input XOR gate

module TopModule(
    input  [3:0] in,  // 4-bit input vector
    output out_and,   // Output of the 4-input AND gate
    output out_or,    // Output of the 4-input OR gate
    output out_xor    // Output of the 4-input XOR gate
);

// Directly using reduction operators for logical operations
// This approach is both concise and efficient for implementing multi-input gates
assign out_and = &in;  // 4-input AND operation
assign out_or  = |in;  // 4-input OR operation
assign out_xor = ^in;  // 4-input XOR operation

endmodule