module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA's logic: (x^y)&x = x&~y
    wire a_out = x & ~y;
    
    // Direct implementation of ModuleB's logic (XNOR)
    wire b_out = ~(x ^ y);
    
    // Final output calculation optimized as:
    // z = (a_out | b_out) ^ (a_out & b_out)
    // Which simplifies to a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule