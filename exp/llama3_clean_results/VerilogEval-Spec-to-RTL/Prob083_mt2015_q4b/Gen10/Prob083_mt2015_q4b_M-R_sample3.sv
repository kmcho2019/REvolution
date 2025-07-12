module TopModule(
    input x,
    input y,
    output z
);
    // Directly assign the result of the expression to the output z
    assign z = !(x ^ y);
endmodule