module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// The K-map simplification does not yield a simpler expression in this case.
// However, we can express the logic in a different form, although it's functionally equivalent.
assign f = (~x3 & x2) | (x3 & x1);

endmodule