module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

// Implementing the logic directly based on the truth table conditions
// with a focus on concise expression for PPA optimization.
assign f = (~x3 & x2) | (x3 & x1);

endmodule