module TopModule(x, y, z);
    input x, y;
    output z;
    
    // Directly implementing the logic based on the truth table analysis
    assign z = (x && !y) || (!x && !y) || (x && y && (x && !y) || (!x && x) || (y && !y));
    
    // However, the above expression seems complex and not simplified.
    // Let's simplify it based on the actual truth table of the given problem.
    // The truth table for z given x and y is as follows:
    // x  y  z
    // 0  0  1
    // 0  1  0
    // 1  0  0
    // 1  1  1
    
    // This can be simplified as:
    assign z = (!x && !y) || (x && y);
    
    // This logic directly implements the required functionality without needing
    // explicit modules A and B, thus potentially simplifying the design.
endmodule