module TopModule(
    input x,
    input y,
    output z
);

    assign z = ~(x ^ y); // Invert the result of the XOR operation between x and y

endmodule