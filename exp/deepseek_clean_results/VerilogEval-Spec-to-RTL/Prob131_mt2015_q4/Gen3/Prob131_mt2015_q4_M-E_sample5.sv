module TopModule(
    input x,
    input y,
    output z
);
    wire xor_xy;
    wire a_out, b_out;
    
    // Shared computation
    assign xor_xy = x ^ y;
    
    // Compute ModuleA and ModuleB outputs once
    assign a_out = xor_xy & x;  // ModuleA function
    assign b_out = ~xor_xy;     // ModuleB function
    
    // Final output calculation
    assign z = (a_out | b_out) ^ (a_out & b_out);
    
    // Alternative minimal implementation (uncomment to use):
    // assign z = x & ~y;
endmodule