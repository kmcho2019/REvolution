module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified expression: f = (~x3 & x2) | (x3 & x1)
assign f = (~x3 & x2) | (x3 & x1);

endmodule