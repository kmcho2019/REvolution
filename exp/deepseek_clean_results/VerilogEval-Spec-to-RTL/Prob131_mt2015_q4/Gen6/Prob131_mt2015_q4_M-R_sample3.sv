module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA outputs directly
    wire a1_out = (x ^ y) & x;
    wire a2_out = (x ^ y) & x;  // Same as a1_out
    
    // Compute ModuleB outputs directly (z = ~x & ~y | x & y)
    wire b1_out = (~x & ~y) | (x & y);
    wire b2_out = (~x & ~y) | (x & y);  // Same as b1_out
    
    // First level logic
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule