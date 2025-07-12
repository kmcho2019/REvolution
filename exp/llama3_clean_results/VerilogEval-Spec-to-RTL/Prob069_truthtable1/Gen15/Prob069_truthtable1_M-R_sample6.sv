module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Intermediate signals for better readability and potential ease of modification
wire cond1, cond2;

// Condition 1: ~x3 && x2
assign cond1 = ~x3 && x2;

// Condition 2: x3 && x1
assign cond2 = x3 && x1;

// Final output based on the conditions
assign f = cond1 || cond2;

endmodule