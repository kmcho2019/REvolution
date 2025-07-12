module TopModule(
    input x,
    input y,
    output z
);
    // Using assign for continuous assignment of the output z based on the inputs x and y.
    // The expression (x == y) is used to determine z, which is equivalent to !(x ^ y) but
    // might be more intuitive for synthesis tools, potentially leading to better optimization.
    assign z = (x == y);
endmodule