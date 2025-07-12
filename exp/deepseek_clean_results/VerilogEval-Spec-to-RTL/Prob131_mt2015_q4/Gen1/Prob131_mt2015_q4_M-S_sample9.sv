module TopModule(
    input x,
    input y,
    output z
);
    // Simplified implementation recognizing the logic reduces to x AND NOT y
    assign z = x & ~y;
endmodule