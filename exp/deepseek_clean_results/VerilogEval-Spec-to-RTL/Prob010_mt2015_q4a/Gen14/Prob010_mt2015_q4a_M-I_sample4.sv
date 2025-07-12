module TopModule (
    input x,
    input y,
    output z
);
    // Optimized direct logic implementation
    assign z = x & (x ^ y);
endmodule