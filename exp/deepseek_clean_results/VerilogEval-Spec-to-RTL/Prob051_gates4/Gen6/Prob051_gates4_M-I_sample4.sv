module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Use reduction operators for all operations
    // Modern synthesis tools will implement optimal structures
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;  // Let synthesis tool choose best XOR implementation

endmodule