module TopModule(
    input x,
    input y,
    output z
);
    // Combined logic expressions
    wire a_out = (x ^ y) & x;      // ModuleA functionality
    wire b_out = ~(x ^ y);         // ModuleB functionality
    
    // Final optimized expression
    assign z = (a_out | b_out) ^ (a_out & b_out);
    
    // Further simplification using Boolean algebra:
    // (a_out | b_out) ^ (a_out & b_out) = a_out ^ b_out
    // So we could also implement as:
    // assign z = a_out ^ b_out;
    // But keeping the original structure for clarity
endmodule