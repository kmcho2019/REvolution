module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimal implementation: 1 AND gate
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Optimal XNOR implementation: 1 XOR + 1 NOT
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
    
    // Final optimized output
    assign z = a_out ^ b_out;  // Mathematically equivalent to original logic
endmodule