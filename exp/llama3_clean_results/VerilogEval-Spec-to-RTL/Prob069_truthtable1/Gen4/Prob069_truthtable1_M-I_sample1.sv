module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The existing implementation is already efficient. 
// To potentially simplify or optimize, consider alternative expressions
// that maintain the same functionality but might offer better PPA metrics.
assign f = (x2 & ~x3) | (x1 & x3);

endmodule