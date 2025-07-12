module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Improved implementation maintaining the same logic but considering PPA.
// Given the simplicity of the current implementation, direct optimization is challenging without technology-specific knowledge.
assign f = (~x3 & x2) | (x3 & x1);

endmodule