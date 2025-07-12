module comparator_3bit(
    input [2:0] A,  // First 3-bit input operand
    input [2:0] B,  // Second 3-bit input operand
    output reg A_greater,  // 1 if A is greater than B
    output reg A_equal,    // 1 if A is equal to B
    output reg A_less      // 1 if A is less than B
);

// Use an always block to define the combinational logic
always @(*)
begin
    // Compare A and B using if-else statements for clarity and potential synthesis benefits
    if (A > B) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (A == B) begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule