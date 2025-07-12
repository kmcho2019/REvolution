// Module definition for a combinational circuit implementing AND, OR, and XOR gates
module TopModule(
    input  [3:0] in, // 4-bit input vector
    output out_and,  // Output of the 4-input AND gate
    output out_or,   // Output of the 4-input OR gate
    output out_xor    // Output of the 4-input XOR gate
);
    // Using reduction operators for efficient implementation
    assign out_and = &in; // 4-input AND operation
    assign out_or  = |in; // 4-input OR operation
    assign out_xor = ^in; // 4-input XOR operation
endmodule