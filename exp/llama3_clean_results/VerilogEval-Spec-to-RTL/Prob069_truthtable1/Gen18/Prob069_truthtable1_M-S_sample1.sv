module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified logical expression
assign f = (x2 & ~x3) | (x1 & x3);

// Alternatively, the expression can be written as:
// assign f = x1 ? x3 : x2;

// Or using a single operation:
assign f = x3 ? x1 : x2;

endmodule