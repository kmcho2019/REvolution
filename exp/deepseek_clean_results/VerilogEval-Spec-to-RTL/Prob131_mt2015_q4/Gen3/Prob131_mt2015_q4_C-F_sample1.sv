module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimized implementation
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Efficient XNOR implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    // Single optimized instances
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized final logic
    assign z = a_out ^ b_out;  // Direct XOR implementation
    
    /* 
    This is equivalent to:
    (a_out | b_out) & ~(a_out & b_out)
    but implemented more efficiently as single XOR
    */
endmodule