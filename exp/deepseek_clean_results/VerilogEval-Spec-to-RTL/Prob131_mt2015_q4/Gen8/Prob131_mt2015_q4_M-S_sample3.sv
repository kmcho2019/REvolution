module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA outputs directly
    wire a_out = (x ^ y) & x;
    
    // Compute ModuleB outputs directly (z = ~x & ~y | x & y)
    wire b_out = ~(x ^ y);
    
    // Combine outputs as specified
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule