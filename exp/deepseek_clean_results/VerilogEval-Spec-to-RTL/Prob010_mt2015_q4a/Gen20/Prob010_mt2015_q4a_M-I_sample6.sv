module TopModule (
    input x,
    input y,
    output z
);
    // Optimized direct implementation
    assign z = x & ~y;
endmodule