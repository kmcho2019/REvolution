module TopModule(
    input x,
    input y,
    output z
);

// The most efficient expression
assign z = ~(x ^ y);

// Alternative implementation for potential optimization
// assign z = (x && y) || (!x &&!y);

endmodule