module TopModule (
    input x,
    input y,
    output z
);
    // Optimal implementation: x & ~y
    assign z = x & ~y;
endmodule