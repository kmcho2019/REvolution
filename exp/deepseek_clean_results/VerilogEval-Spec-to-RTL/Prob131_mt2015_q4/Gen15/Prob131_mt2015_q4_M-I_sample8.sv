module ModuleA(
    input x,
    input y,
    output z
);
    // Original: z = (x^y) & x
    // Optimized: z = x & ~y (same as original)
    assign z = x & ~y;
endmodule

module ModuleB(
    input x,
    input y,
    output z
);
    // Maintain XNOR functionality matching waveform
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
    
    // Optimized final output calculation:
    // Original: z = (a_out OR b_out) XOR (a_out AND b_out)
    // Which simplifies to: z = a_out XOR b_out
    // This is already optimal, so we maintain it
    assign z = a_out ^ b_out;
endmodule