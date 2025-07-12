module TopModule(
    input x,
    input y,
    output z
);
    // Implement the logic using a K-map reduced expression
    assign z = ~(x ^ y);
endmodule