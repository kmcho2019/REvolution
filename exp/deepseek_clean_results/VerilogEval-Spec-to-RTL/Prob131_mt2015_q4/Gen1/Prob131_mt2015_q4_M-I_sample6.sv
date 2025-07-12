module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Simplified from (x^y) & x
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = x & y;  // Direct implementation from truth table
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    wire or_out, and_out;
    
    // Single instances since outputs would be identical
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // First level logic - reuse same outputs for both operations
    assign or_out = a_out | b_out;
    assign and_out = a_out & b_out;
    
    // Final output
    assign z = or_out ^ and_out;
endmodule