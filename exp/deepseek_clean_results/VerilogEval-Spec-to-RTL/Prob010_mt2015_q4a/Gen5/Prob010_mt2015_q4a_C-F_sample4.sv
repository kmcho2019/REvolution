module TopModule (
    input x,
    input y,
    output z
);
    // Implements z = (x^y) & x which simplifies to x & ~y
    assign z = x & ~y;
endmodule