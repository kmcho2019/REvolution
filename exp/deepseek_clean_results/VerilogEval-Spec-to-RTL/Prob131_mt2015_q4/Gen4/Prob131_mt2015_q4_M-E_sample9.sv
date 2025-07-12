module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimized version of (x^y)&x
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // XNOR implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out;
    wire b_out;
    
    // Single instances since outputs would be identical
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized final logic:
    // Original: z = (a_out | b_out) ^ (a_out & b_out)
    // Which simplifies to: z = a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule