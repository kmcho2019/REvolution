module TopModule (
    input x,
    input y,
    output z
);
    // Direct implementation of optimized function z = x & ~y
    assign z = x & ~y;
endmodule