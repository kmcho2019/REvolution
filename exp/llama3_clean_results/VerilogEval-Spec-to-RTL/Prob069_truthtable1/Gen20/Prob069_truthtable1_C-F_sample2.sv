module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified logical expression within a continuous assignment
assign f = (x2 & ~x3) | (x1 & x3);

endmodule