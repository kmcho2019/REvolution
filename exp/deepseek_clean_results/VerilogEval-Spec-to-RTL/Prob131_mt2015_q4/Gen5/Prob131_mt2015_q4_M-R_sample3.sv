module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of ModuleA logic: (x^y)&x which simplifies to x&~y
    wire a_out = x & ~y;
    
    // Direct implementation of ModuleB logic: XNOR (~(x^y))
    wire b_out = ~(x ^ y);
    
    // Final optimized XOR of (a_out OR b_out) AND (a_out AND b_out)
    assign z = a_out ^ b_out;
endmodule