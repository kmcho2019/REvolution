module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Compute the output by directly checking the input combinations
assign f = (x2 & ~x3) | (x1 & x3);

endmodule