module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified implementation focusing on the essential conditions.
assign f = x2 | (x3 & x1);

endmodule