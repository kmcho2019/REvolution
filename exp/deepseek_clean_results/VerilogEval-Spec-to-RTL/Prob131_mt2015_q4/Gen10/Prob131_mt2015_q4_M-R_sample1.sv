module TopModule(
    input x,
    input y,
    output z
);
    // Original logic broken down:
    // ModuleA: (x ^ y) & x = x & ~y
    // ModuleB: ~(x ^ y) = x ~^ y = (x & y) | (~x & ~y)
    // Final logic: ((a1_out | b1_out) ^ (a2_out & b2_out))
    
    // After algebraic simplification:
    // z = (x & ~y) ^ (x & y)
    // Which simplifies to: x ^ (x & y)
    // Or even simpler: x & ~y
    
    // However, looking at the truth table from the original implementation:
    // The correct final expression is actually: x & ~y
    
    assign z = x & ~y;
endmodule