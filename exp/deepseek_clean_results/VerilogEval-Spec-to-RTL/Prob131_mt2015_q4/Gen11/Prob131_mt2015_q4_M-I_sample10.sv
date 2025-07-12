module TopModule(
    input x,
    input y,
    output z
);
    // Direct optimized implementation: z = x | ~y
    assign z = x | ~y;
endmodule