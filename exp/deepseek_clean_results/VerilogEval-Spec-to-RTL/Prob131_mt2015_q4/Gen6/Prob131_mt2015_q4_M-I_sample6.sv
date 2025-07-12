module TopModule(
    input x,
    input y,
    output z
);
    // Compute shared terms once
    wire x_xor_y = x ^ y;
    wire x_nor_y = ~(x | y);
    wire x_and_y = x & y;
    
    // Module A equivalent (optimized)
    wire a_out = x_xor_y & x;
    
    // Module B equivalent (optimized XNOR)
    wire b_out = x_nor_y | x_and_y;
    
    // Intermediate logic
    wire or_out = a_out | b_out;
    wire and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule