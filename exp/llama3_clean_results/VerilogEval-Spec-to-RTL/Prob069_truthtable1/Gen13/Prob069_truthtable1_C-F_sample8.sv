module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Using the most efficient logical expression that represents the required logic
assign f = (x2 & ~x3) | (x1 & x3);

endmodule