module TopModule (
    input x,
    input y,
    output z
);
    // Optimized implementation of z = (x^y) & x
    // Boolean algebra reduction: (x^y) & x = x & ~y
    // Using intermediate signals for clarity while maintaining optimization
    
    wire y_inverted;
    
    assign y_inverted = ~y;
    assign z = x & y_inverted;
endmodule