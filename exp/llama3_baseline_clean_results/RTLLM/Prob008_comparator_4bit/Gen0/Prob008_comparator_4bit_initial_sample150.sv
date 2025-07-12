module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Internal signals for borrow and result
wire borrow;
reg [3:0] result;

// Perform subtraction A - B
always @(A or B) begin
    {borrow, result[3:0]} = A - B;
end

// Output encoding
assign A_greater = (~borrow) && (|result);
assign A_equal = (~borrow) && ~(|result);
assign A_less = borrow;

endmodule