module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA output once (z = (x^y) & x)
    wire a_out = (x ^ y) & x;
    
    // Compute ModuleB output once (z = (~x & ~y) | (x & y))
    wire b_out = (~x & ~y) | (x & y);
    
    // First level logic (OR and AND of same signals)
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule