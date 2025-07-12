module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y); // Using XOR and inverting the result to achieve XNOR

// Alternatively, the following line can also be used for XNOR operation
// assign z = (x == y);

endmodule