module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Direct implementation using a concise Boolean expression
// Potential optimization could involve using synthesis directives
// to prioritize area and power optimization, depending on the synthesis tool
assign f = (x2 & ~x3) | (x1 & x3);

endmodule