module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly implement the simplified logic expression
assign f = (x2 & ~x3) | (x1 & x3);

endmodule