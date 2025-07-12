module TopModule(
    input a,
    input b,
    output out
);

// Detect when both inputs are 1
wire both_one;
assign both_one = a & b;

// Detect when both inputs are 0
wire both_zero;
assign both_zero = ~(a | b);

// Combine the results to produce the final output
assign out = both_one | both_zero;

endmodule