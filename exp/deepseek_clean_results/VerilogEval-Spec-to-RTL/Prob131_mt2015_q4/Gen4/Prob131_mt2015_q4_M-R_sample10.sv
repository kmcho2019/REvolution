module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA function once (z = (x^y) & x)
    wire a_out = (x ^ y) & x;
    
    // Compute ModuleB function once (z = ~x&~y | x&y)
    wire b_out = (~x & ~y) | (x & y);
    
    // First level logic
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule