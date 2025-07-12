module comparator_4bit (
    input  [3:0] A,
    input  [3:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

// Combinational comparison using built-in operators
assign A_less    = (A < B);
assign A_equal   = (A == B);
assign A_greater = (A > B);

endmodule