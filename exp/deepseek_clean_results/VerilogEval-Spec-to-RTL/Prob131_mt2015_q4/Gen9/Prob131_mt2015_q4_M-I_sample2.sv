module ModuleA(
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Optimized implementation: equivalent to (x^y)&x
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    // Direct implementation matching waveform pattern:
    // z = 1 when (x,y)=(0,0) or (1,1), else 0
    assign z = ~(x ^ y);  // Maintains XNOR functionality
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
    
    // Final optimized XOR
    assign z = a_out ^ b_out;
endmodule