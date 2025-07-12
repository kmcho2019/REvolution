module TopModule(
    input x,
    input y,
    output z
);
    // Optimized single-expression implementation
    assign z = x | ~y;
endmodule