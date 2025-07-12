module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Direct arithmetic comparison with mutually exclusive outputs
assign A_equal = (A == B);
assign A_greater = ~A_equal & (A > B);
assign A_less = ~A_equal & ~A_greater;

endmodule