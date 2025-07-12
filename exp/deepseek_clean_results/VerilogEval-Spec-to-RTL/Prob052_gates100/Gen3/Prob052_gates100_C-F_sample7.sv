module TopModule (
    input [99:0] in,       // 100-bit input vector
    output out_and,        // AND reduction of all inputs
    output out_or,         // OR reduction of all inputs
    output out_xor         // XOR reduction of all inputs
);

    // Using Verilog reduction operators for optimal synthesis:
    // - Synthesizes to efficient tree structures
    // - Provides best PPA characteristics
    // - Clear behavioral description
    
    assign out_and = &in;  // Outputs 1 only if ALL 100 bits are 1
    assign out_or  = |in;  // Outputs 1 if ANY of the 100 bits is 1
    assign out_xor = ^in;  // Outputs 1 if ODD number of bits are 1

endmodule