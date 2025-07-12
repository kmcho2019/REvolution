module TopModule(
    input x,
    input y,
    output z
);
    // Compute common terms once
    wire x_xor_y = x ^ y;
    wire b_out = ~x_xor_y;  // Module B equivalent
    
    // Module A equivalent: (x^y) & x
    wire a_out = x_xor_y & x;
    
    // First level logic
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule