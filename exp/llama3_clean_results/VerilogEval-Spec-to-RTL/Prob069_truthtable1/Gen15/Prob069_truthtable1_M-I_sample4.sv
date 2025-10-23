module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified logic expression maintaining the same functionality
assign f = (~x3 & x2) | (x1 & x3);

endmodule