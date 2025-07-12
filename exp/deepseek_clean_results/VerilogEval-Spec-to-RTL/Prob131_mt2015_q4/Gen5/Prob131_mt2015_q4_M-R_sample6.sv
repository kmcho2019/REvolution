module TopModule(
    input x,
    input y,
    output z
);
    // Module A equivalent logic (z = (x^y) & x)
    wire a1_out = (x ^ y) & x;
    wire a2_out = (x ^ y) & x;
    
    // Module B equivalent logic (truth table implementation)
    wire b1_out = (~x & ~y) | (x & y);
    wire b2_out = (~x & ~y) | (x & y);
    
    // First level logic
    wire or_path = a1_out | b1_out;
    wire and_path = a2_out & b2_out;
    
    // Final output
    assign z = or_path ^ and_path;
endmodule