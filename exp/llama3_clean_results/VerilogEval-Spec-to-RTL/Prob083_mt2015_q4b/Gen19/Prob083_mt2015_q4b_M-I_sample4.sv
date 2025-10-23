module TopModule(
    input x,
    input y,
    output z
);
    // Alternative implementation using the XOR and NOT operations
    // This expression is logically equivalent to (x == y) but uses XOR and NOT
    assign z = !(x ^ y);
endmodule