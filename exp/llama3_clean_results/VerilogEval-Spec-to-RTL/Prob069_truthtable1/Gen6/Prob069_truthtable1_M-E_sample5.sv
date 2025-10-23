module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implement the logic based on the observed patterns in the truth table.
// The output f is 1 whenever x2 is 1 or both x1 and x3 are 1.
assign f = (x2) | (x1 & x3);

endmodule