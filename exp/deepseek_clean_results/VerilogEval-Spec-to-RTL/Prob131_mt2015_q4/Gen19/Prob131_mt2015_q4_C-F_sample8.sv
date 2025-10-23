module TopModule(
    input x,
    input y,
    output z
);
    // Fully optimized and flattened implementation
    assign z = (x & ~y) ^ ~(x ^ y);
endmodule