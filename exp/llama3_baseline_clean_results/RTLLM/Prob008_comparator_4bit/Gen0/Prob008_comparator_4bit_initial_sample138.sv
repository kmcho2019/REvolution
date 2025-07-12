module comparator_4bit (
    input  [3:0] A,  // First 4-bit input operand
    input  [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Internal signals for borrow and result of subtraction
reg [3:0] result;
reg borrow;

// Perform subtraction operation (A - B)
always @(*) begin
    result = A - B;
    borrow = (A < B) ? 1 : 0;
end

// Generate output signals based on borrow and result
always @(*) begin
    A_greater = (~borrow && (result != 4'b0000)) ? 1 : 0;
    A_equal = (borrow && (result == 4'b0000)) || (~borrow && (result == 4'b0000)) ? 1 : 0;
    A_less = borrow ? 1 : 0;
end

endmodule