module ModuleA(
    input x,
    input y,
    output z
);
    // Combined XOR operation with original logic: z = ((x^y)&x) ^ b_out
    // Which simplifies to: z = (x & ~y) ^ b_out
    assign z = (x & ~y);
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    // Maintain XNOR functionality (most efficient implementation)
    assign z = ~(x ^ y);
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    wire a_out, b_out;
    
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Final XOR operation (now the only XOR in design)
    assign z = a_out ^ b_out;
endmodule