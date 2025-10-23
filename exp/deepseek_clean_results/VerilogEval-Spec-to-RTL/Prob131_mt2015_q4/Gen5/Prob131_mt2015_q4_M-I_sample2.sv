module ModuleA(
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;  // Original optimal implementation
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Simplified from case statement to single equation
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
    
    // Combined logic
    assign z = (a_out | b_out) ^ (a_out & b_out);
endmodule