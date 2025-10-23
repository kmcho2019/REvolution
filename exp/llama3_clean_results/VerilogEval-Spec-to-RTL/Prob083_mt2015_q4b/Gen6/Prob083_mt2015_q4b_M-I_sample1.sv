module TopModule(
    input  x,
    input  y,
    output z
);

// Using a more power-efficient logic structure, such as the ^ operator (XOR) and inverting the result
assign z = ~(x ^ y);

endmodule