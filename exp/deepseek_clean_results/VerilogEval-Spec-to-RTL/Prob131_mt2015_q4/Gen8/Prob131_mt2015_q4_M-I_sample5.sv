module TopModule(
    input x,
    input y,
    output z
);
    // Module A logic: z = (x^y) & x
    wire a1_out = (x ^ y) & x;
    wire a2_out = a1_out;  // Same logic as a1_out
    
    // Module B logic simplified: z = x & y
    wire b1_out = x & y;
    wire b2_out = b1_out;  // Same logic as b1_out
    
    // First level logic
    wire or_out = a1_out | b1_out;
    wire and_out = a2_out & b2_out;
    
    // Final output
    assign z = or_out ^ and_out;
    
    // Alternative fully optimized expression:
    // assign z = ((x^y)&x | x&y) ^ ((x^y)&x & x&y);
    // This could be further optimized but kept separate for clarity
endmodule