module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimized from (x^y)&x
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    assign z = ~(x ^ y);  // Direct XNOR implementation
endmodule

module TopModule(
    input x,
    input y,
    output z
);
    // Single instances since all inputs are identical
    wire a_out = x & ~y;      // Inlined ModuleA
    wire b_out = ~(x ^ y);    // Inlined ModuleB
    
    // Final optimized output
    assign z = a_out ^ b_out;
endmodule