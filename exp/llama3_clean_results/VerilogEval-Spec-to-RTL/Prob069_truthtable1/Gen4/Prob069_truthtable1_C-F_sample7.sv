module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Direct implementation of the logic derived from the truth table
assign f = (x2 & ~x3) | (x1 & x3) | (x1 & x2);

endmodule