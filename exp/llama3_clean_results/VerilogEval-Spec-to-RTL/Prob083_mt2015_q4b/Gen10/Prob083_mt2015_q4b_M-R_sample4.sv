module TopModule(
    input x,
    input y,
    output z
);
    // Using assign for continuous assignment of the output z based on the inputs x and y.
    // The output z is 1 when x and y are the same (both 0 or both 1), which is efficiently
    // represented by the expression!(x ^ y).
    assign z =!(x ^ y);
endmodule