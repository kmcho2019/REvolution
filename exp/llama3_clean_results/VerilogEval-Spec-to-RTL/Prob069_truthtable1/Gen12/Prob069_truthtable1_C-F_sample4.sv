module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly implementing the logic based on the truth table conditions
assign f = (x2 & ~x3) | (x1 & x3);

endmodule