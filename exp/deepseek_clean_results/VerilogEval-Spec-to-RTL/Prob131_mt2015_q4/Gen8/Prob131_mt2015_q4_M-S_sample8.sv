module TopModule(
    input x,
    input y,
    output z
);
    // Compute ModuleA output once (z = (x^y) & x)
    wire a_out = (x ^ y) & x;
    
    // Compute ModuleB output once (z = (~x & ~y) | (x & y))
    wire b_out = (~x & ~y) | (x & y);
    
    // Combine outputs with OR, AND, and XOR
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule