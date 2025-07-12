// Optimal XNOR gate implementation
module TopModule (
    input a,
    input b,
    output out
);
    // Primary implementation: direct XNOR operator (best PPA)
    assign out = a ~^ b;
    
    /* Alternative implementations for reference:
    // 1. Ternary operator implementation (from Example 1)
    // assign out = (a == b) ? 1'b1 : 1'b0;
    
    // 2. Structural implementation (shows XOR-XNOR relationship)
    // wire xor_out;
    // assign xor_out = a ^ b;
    // assign out = ~xor_out;
    */
endmodule