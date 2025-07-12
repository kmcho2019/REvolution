module TopModule(
    input x,
    input y,
    output z
);

// Directly assign the expression ~(x ^ y) to the output z
assign z = ~(x ^ y);

endmodule