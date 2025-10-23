module TopModule (
    input x,
    input y,
    output z
);
    // Simplified implementation: z = x & ~y
    assign z = x & ~y;
endmodule