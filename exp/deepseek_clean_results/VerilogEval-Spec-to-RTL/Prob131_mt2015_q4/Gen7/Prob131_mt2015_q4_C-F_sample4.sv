module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Original optimized expression
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = (~x & ~y) | (x & y);  // Simplified Boolean expression matching truth table
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
    
    // Optimized final output: (a|b)^(a&b) == a^b
    assign z = a_out ^ b_out;
endmodule