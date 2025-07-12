module TopModule (
    input x,
    input y,
    output z
);
    wire xor_xy;  // Intermediate signal for XOR result
    wire not_y;   // Intermediate signal for NOT y
    
    assign not_y = ~y;
    assign xor_xy = x ^ y;  // This is actually redundant but shown for clarity
    assign z = x & not_y;   // Final AND operation
    
    // Note: The xor_xy isn't actually used in the final calculation
    // since the simplified form is x & ~y, but we include it to show
    // the thought process behind the original function z = (x^y) & x
endmodule