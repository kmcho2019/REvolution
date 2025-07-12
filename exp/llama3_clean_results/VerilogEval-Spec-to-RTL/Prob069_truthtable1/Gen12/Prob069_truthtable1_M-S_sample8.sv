module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified implementation based on the truth table conditions.
assign f = (~x3 & x2) | (x3 & x1);

endmodule