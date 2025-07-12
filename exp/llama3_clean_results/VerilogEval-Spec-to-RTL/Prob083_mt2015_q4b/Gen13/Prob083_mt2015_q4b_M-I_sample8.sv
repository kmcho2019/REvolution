module TopModule(
    input x,
    input y,
    output z
);

// Alternative implementation using direct comparison
// assign z = (x && y) || (!x && !y);
assign z = ~(x ^ y); // This remains the most straightforward and efficient implementation

endmodule