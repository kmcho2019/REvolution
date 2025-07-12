module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Maintain the simple and efficient logical expression
// This expression directly implements the required logic and is conducive to good PPA metrics
assign f = (x2 && ~x3) || (x1 && x3);

endmodule