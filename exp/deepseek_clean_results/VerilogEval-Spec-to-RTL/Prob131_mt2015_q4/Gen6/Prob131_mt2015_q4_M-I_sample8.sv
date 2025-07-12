module TopModule(
    input x,
    input y,
    output z
);
    // Compute common subexpressions once
    wire x_and_not_y = x & ~y;
    wire x_xnor_y = ~(x ^ y);
    
    // Final logic
    assign z = (x_and_not_y | x_xnor_y) ^ (x_and_not_y & x_xnor_y);
endmodule