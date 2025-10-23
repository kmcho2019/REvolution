module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Simplified from (x^y)&x
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
    wire a_out, b_out;
    
    // Single instances since all inputs are identical
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized final output: (a_out ^ b_out)
    assign z = a_out ^ b_out;
endmodule