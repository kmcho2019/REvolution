module TopModule(
    input x,
    input y,
    output z
);
    // The output z is 1 when x and y are the same (both 0 or both 1),
    // which can be efficiently represented using the XOR operator (^).
    // The! operator inverts the result, making z high when x equals y.
    assign z =!(x ^ y);
endmodule