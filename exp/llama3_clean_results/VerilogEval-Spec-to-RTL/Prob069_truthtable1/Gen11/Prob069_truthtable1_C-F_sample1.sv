module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Directly implement the simplified logic expression
// This approach allows for efficient synthesis and optimization by the synthesis tool
assign f = (x2 & ~x3) | (x1 & x3);

endmodule