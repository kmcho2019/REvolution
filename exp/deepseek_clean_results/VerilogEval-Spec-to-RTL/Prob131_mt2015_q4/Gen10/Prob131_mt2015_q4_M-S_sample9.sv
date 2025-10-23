module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation combining all logic:
    // z = [(x^y & x) | ~(x^y)] ^ [(x^y & x) & ~(x^y)]
    // Simplified further using boolean algebra:
    assign z = ((x & ~y) | (~x & ~y)) ^ (x & ~y & ~(x ^ y));
    // Final simplification:
    assign z = (~y) ^ (x & ~y);
endmodule