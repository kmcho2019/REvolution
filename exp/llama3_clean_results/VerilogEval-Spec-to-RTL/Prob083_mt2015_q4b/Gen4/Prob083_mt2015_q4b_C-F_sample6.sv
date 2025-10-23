module TopModule(
    input x,
    input y,
    output z
);
    // Using the most efficient logic implementation
    assign z = ~(x ^ y);
endmodule