module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Single arithmetic comparison operation
wire greater = (A > B);
wire equal = (A == B);

// Output assignments - mutually exclusive by construction
assign A_greater = greater;
assign A_equal = equal;
assign A_less = ~greater & ~equal;

endmodule