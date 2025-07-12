module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintain the same logical expression for simplicity and efficiency
assign f = (x2 && ~x3) || (x1 && x3);

endmodule