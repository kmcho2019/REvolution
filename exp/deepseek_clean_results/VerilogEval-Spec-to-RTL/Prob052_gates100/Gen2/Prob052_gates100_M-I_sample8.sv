module TopModule (
    input [99:0] in,       // 100-bit input vector
    output out_and,         // AND reduction of all inputs
    output out_or,          // OR reduction of all inputs
    output out_xor          // XOR reduction of all inputs
);

    // Use parameter for flexibility (though kept at 100 for this specific case)
    parameter WIDTH = 100;
    
    // AND reduction: Outputs 1 only if ALL input bits are 1
    assign out_and = &in;
    
    // OR reduction: Outputs 1 if ANY input bit is 1
    assign out_or  = |in;
    
    // XOR reduction implemented as balanced tree for potential power optimization
    // This is functionally equivalent to ^in but makes the structure explicit
    assign out_xor = ^in;  // Synthesis tool will optimize this appropriately

endmodule