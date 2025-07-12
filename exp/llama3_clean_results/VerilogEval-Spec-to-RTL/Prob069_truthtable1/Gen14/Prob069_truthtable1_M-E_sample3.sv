module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implementing the logic based on K-map simplification or pattern recognition
assign f = (~x3 && x2) || (x3 && x1);

endmodule