module TopModule(
    input x,
    input y,
    output z
);
    // Direct implementation of the optimized logic:
    // z = (x & ~y) ^ ~(x ^ y)
    // Which simplifies to: x ^ y ^ ~(x ^ y) when expanded
    // But we'll implement the most efficient form:
    assign z = (x & ~y) ^ ~(x ^ y);
endmodule