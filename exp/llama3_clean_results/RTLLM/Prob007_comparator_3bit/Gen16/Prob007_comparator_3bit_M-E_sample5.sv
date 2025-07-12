module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [2:0] result;
reg borrow;

always @(*)
begin
    // Perform binary subtraction (A - B)
    {borrow, result} = A - B;

    // Analyze the result and borrow flag to determine the relationship between A and B
    if (borrow == 1'b0 && result!= 3'b000) begin
        // A is greater than B if there is no borrow and the result is not zero
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (borrow == 1'b0 && result == 3'b000) begin
        // A is equal to B if there is no borrow and the result is zero
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin
        // A is less than B if there is a borrow
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule