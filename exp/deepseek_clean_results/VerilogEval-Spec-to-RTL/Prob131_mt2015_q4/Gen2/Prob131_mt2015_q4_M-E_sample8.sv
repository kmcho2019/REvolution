module ModuleA(
    input x,
    input y,
    output z
);
    // Original implementation remains the same
    assign z = (x ^ y) & x;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    // Optimized to use XNOR operation which matches the truth table
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    wire intermediate;
    
    // Single instances of each module
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized logic combining both paths
    // Equivalent to (a_out | b_out) ^ (a_out & b_out)
    // Which simplifies to a_out ^ b_out
    assign z = a_out ^ b_out;
endmodule