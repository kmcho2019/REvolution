module TopModule (
    input x,
    input y,
    output z
);
    // Implements z = (x XOR y) AND x, which simplifies to x AND NOT y
    assign z = x & ~y;
endmodule