module TopModule(
    input x,
    input y,
    output z
);
    wire xor_xy, a_out, b_out;
    
    // Shared XOR computation
    assign xor_xy = x ^ y;
    
    // Compute ModuleA and ModuleB outputs
    assign a_out = x & ~y;        // (x^y)&x simplifies to x&~y
    assign b_out = ~xor_xy;       // XNOR is complement of XOR
    
    // Final output logic
    assign z = a_out ^ b_out;     // Equivalent to (a_out OR b_out) XOR (a_out AND b_out)
endmodule