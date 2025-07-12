module TopModule(
    input x,
    input y,
    output z
);
    // Optimized implementation: Entire logic reduces to ~y
    assign z = ~y;
endmodule