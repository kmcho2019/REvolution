module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA and ModuleB logic
    wire a_out = x & ~y;        // Original ModuleA logic
    wire b_out = ~(x ^ y);      // Original ModuleB logic
    
    // Final output calculation
    assign z = a_out ^ b_out;   // Mathematically equivalent to original
endmodule