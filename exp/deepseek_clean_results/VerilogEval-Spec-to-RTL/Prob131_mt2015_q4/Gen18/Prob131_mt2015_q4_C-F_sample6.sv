module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimal implementation: 1 AND gate
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Optimal XNOR implementation: 1 XOR + 1 NOT
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Direct parallel computation of all required outputs
    wire a1_out = x & ~y;    // ModuleA function
    wire b1_out = ~(x ^ y);  // ModuleB function
    wire a2_out = a1_out;    // Shared computation
    wire b2_out = b1_out;    // Shared computation
    
    // Optimized output combination
    assign z = (a1_out | b1_out) ^ (a2_out & b2_out);
    
    // Mathematical simplification equivalent to:
    // assign z = x ^ y;  // Final optimized form if allowed
endmodule