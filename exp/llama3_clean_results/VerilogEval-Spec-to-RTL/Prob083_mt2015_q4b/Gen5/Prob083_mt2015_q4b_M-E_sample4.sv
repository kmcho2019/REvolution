module TopModule(
    input x,
    input y,
    output z
);

// Implementation using XOR and NOT operators based on K-map analysis
assign z = ~(x ^ y);

endmodule