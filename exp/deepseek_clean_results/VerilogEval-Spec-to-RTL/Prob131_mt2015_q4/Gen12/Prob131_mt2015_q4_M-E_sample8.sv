module TopModule(
    input x,
    input y,
    output z
);
    // Unified processing for both functions
    wire a_func = x & ~y;  // Equivalent to ModuleA's (x^y)&x
    
    // Truth-table implementation of ModuleB
    wire b_func = (x == y) ? 1'b1 : 1'b0;
    
    // Arithmetic implementation of final XOR (sum mod 2)
    assign z = (a_func + b_func) % 2;
endmodule