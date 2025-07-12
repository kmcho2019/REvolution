module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is already efficient. 
// To potentially simplify or optimize, consider alternative expressions
// that maintain the same functionality but might offer better PPA metrics.
// Given the truth table and the current expression, we can also express it as:
assign f = (~x3 & x2) | (x3 & x1);

endmodule