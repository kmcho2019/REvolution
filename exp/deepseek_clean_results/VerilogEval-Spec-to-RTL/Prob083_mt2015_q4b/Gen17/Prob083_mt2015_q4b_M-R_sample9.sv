module TopModule (
    input x,
    input y,
    output z
);
    // Implement XNOR using ternary conditional operator
    // z = 1 when x equals y, 0 otherwise
    assign z = (x == y) ? 1'b1 : 1'b0;
endmodule