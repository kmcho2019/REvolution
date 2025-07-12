module TopModule(
    input x,
    input y,
    output z
);
    // Compute all required intermediate signals directly
    wire a_out = (x ^ y) & x;  // ModuleA functionality
    wire b_out = ~(x ^ y);      // ModuleB functionality
    
    // Final combined logic optimized using Boolean algebra:
    // Original: (a_out | b_out) ^ (a_out & b_out)
    // Simplified to: a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule