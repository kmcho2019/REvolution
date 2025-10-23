module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA logic
    wire a1_out = (x ^ y) & x;
    wire a2_out = a1_out;  // Same logic for both A modules
    
    // Shared ModuleB logic implementation
    wire b_out = ~(x ^ y);  // Equivalent to x XNOR y which matches the truth table
    
    // First level logic
    wire or_out = a1_out | b_out;
    wire and_out = a2_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule