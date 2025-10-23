module TopModule(
    input x,
    input y,
    output z
);
    // Implement the logic using the efficient expression !(x ^ y)
    assign z = !(x ^ y);
endmodule