module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Using XOR and inverting the result
// Alternatively, you could also use: assign z = (x == y);

endmodule