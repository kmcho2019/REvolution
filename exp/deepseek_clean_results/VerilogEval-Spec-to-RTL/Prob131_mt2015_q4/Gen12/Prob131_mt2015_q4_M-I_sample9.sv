module TopModule(
    input x,
    input y,
    output z
);
    // Optimized single Boolean expression
    assign z = ~x & ~y;
endmodule