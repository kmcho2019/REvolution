// Refactored solution using a continuous assignment with a conditional operator.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Implement the logic using a conditional operator for a different structure.
assign out = (a || b || c) ? 1'b1 : 1'b0;

endmodule