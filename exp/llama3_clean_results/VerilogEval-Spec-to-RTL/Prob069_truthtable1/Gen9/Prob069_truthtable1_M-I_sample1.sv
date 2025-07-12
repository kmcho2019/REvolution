module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// Directly implement the logic based on the observed patterns in the truth table
assign f = x2 || (x3 && x1);

endmodule