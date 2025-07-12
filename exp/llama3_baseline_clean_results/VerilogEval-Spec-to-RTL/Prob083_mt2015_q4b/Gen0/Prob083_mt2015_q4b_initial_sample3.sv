module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Using XOR and NOT operators
// Alternatively, using the equality operator
// assign z = (x == y);

endmodule