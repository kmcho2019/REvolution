module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified expression based on direct observation of the truth table
assign f = (x2 && !x3) || (x1 && x3);

// This expression captures the conditions under which 'f' is 1, omitting the redundant case of (x2 && x1)
// which is already covered by the other conditions.

endmodule