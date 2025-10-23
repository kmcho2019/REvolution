module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // This remains the most straightforward and efficient implementation

// Alternatively, for clarity or if the technology favors AND/OR over XOR for some reason:
// assign z = (x && y) || (!x && !y);

endmodule