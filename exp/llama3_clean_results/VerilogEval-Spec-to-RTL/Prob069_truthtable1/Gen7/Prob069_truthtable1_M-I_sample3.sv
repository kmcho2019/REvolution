module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintaining the efficient implementation, considering the logic's simplicity and the metrics.
assign f = (x2 & ~x3) | (x1 & x3);

endmodule