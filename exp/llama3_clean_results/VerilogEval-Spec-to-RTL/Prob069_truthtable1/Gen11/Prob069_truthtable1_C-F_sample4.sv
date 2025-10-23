module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly assign the output based on the simplified conditions
assign f = (x2 & ~x3) | (x1 & x3);

endmodule