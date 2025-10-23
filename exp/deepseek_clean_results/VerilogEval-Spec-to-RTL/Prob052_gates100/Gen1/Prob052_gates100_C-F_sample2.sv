module TopModule (
    input [99:0] in,       // 100-bit input vector
    output out_and,         // AND reduction of all inputs
    output out_or,          // OR reduction of all inputs
    output out_xor          // XOR reduction of all inputs
);

    // AND reduction: Outputs 1 only if ALL input bits are 1
    assign out_and = &in;
    
    // OR reduction: Outputs 1 if ANY input bit is 1
    assign out_or  = |in;
    
    // XOR reduction: Outputs 1 if ODD number of input bits are 1
    assign out_xor = ^in;

endmodule