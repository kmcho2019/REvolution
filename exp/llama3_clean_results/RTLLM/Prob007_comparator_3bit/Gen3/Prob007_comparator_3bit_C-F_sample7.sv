module comparator_3bit(
    input [2:0] A, // First 3-bit input operand
    input [2:0] B, // Second 3-bit input operand
    output reg A_greater, // 1 if A is greater than B
    output reg A_equal,   // 1 if A is equal to B
    output reg A_less     // 1 if A is less than B
);

// Combinational logic to compare A and B and assign results to outputs
always @(*) begin
    A_greater = (A > B); // A is greater than B
    A_equal = (A == B);   // A is equal to B
    A_less = (A < B);     // A is less than B
end

endmodule