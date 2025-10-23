module TopModule(
    input x,
    input y,
    output z
);

assign z = ~(x ^ y);  // Using XOR and inverting the result to get XNOR

endmodule