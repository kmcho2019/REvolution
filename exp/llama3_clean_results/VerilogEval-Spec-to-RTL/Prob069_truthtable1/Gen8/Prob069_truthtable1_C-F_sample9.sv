module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintaining the simplicity and directness of the original implementation
assign f = (x2 & ~x3) | (x1 & x3);

endmodule