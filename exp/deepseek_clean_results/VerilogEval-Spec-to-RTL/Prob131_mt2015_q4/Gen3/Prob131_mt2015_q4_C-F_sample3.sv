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
    assign z = ~(x ^ y);  // XNOR implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    wire or_out, and_out;
    
    // Single instances with fanned-out outputs
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // First level logic
    assign or_out = a_out | b_out;  // OR of single A and B outputs
    assign and_out = a_out & b_out; // AND of same outputs
    
    // Final output
    assign z = or_out ^ and_out;
endmodule