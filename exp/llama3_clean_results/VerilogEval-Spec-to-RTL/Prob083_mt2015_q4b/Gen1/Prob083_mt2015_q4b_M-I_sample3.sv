// The optimized code remains the same as the original due to its simplicity and efficiency.
module TopModule(
    input x,
    input y,
    output z
);
    assign z = (x & y) | ~(x | y);
endmodule