module TopModule(
    input x,
    input y,
    output z
);

// Improved implementation using alternative logical representation
assign z = ~(x ^ ~y); // This implementation might have lower switching activity

// Alternative implementation using direct comparison
// assign z = (x && y) || (!x && !y);

endmodule