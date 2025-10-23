module OptimizedModule(
    input x,
    input y,
    output a_out,
    output b_out
);
    // Combined logic for both original modules
    assign a_out = x & (~y);  // Equivalent to (x^y)&x
    assign b_out = ~(x ^ y);  // Same as original ModuleB
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    // Single optimized instance
    OptimizedModule combined(.x(x), .y(y), .a_out(a_out), .b_out(b_out));
    
    // Final optimized output
    assign z = a_out ^ b_out;
endmodule