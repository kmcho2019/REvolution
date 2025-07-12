module TopModule(
    input x,
    input y,
    output z
);
    // Using the inverse of the XOR operation for a novel implementation
    assign z = ~(x ^ y);
endmodule