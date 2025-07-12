module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Optimal implementation
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Simplified power-efficient implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    // Single instances with output fanout
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized final logic: (a|b)^(a&b) == a^b
    assign z = a_out ^ b_out;
endmodule