module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified expression focusing on essential conditions for 'f' to be 1
assign f = (x2 &&!x3) || (x1 && x3);

// This expression captures the conditions under which 'f' is 1, based on the truth table,
// and omits the redundant condition, thus simplifying the logic and potentially improving PPA metrics.

endmodule