module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of the optimized logic
    assign z = (x & ~y) ^ ~(x ^ y);
endmodule