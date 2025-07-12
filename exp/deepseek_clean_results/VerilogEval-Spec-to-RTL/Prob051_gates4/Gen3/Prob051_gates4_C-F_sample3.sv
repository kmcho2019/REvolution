module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Optimal implementation using reduction operators for all operations
    assign out_and = &in;  // 4-input AND
    assign out_or  = |in;  // 4-input OR
    assign out_xor = ^in;  // 4-input XOR (synthesis tools will optimize the tree structure)

endmodule