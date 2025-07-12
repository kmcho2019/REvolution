module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    // Direct Boolean implementation of the truth table
    assign z = ~(x | y) | (x & y);
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    // Single instances since inputs are identical
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized logic - equivalent to original but with fewer operations
    // Original: z = (a1_out | b1_out) ^ (a2_out & b2_out)
    // Since a1_out = a2_out and b1_out = b2_out, simplifies to:
    assign z = (a_out | b_out) ^ (a_out & b_out);
    
    // Further Boolean optimization:
    // (a|b)^(a&b) is equivalent to a^b
    // assign z = a_out ^ b_out;  // Even simpler equivalent
endmodule