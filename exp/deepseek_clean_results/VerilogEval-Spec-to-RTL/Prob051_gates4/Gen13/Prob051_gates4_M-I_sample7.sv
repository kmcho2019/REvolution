module TopModule (
    input [3:0] in,       // 4-bit input vector
    output out_and,       // 4-input AND: true only if all inputs are 1
    output out_or,        // 4-input OR: true if any input is 1
    output out_xor        // 4-input XOR: true if odd number of inputs are 1
);

    // Use reduction operators for all operations
    assign out_and = &in; // AND reduction
    assign out_or  = |in; // OR reduction
    assign out_xor = ^in; // XOR reduction (modern tools optimize this well)

endmodule