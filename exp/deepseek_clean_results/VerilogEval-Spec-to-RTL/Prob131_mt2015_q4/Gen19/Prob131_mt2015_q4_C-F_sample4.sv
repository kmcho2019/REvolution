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
    
    // Single instance of each module
    ModuleA A(.x(x), .y(y), .z(a_out));
    ModuleB B(.x(x), .y(y), .z(b_out));
    
    // Optimized output logic: (A|B) ^ (A&B) = A^B
    assign z = a_out ^ b_out;
endmodule