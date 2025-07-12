module TopModule(
    input x,
    input y,
    output z
);

// Alternative implementation for potential optimization
// assign z = (x && y) || (!x && !y);
assign z = ~(x ^ y);

endmodule