module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [2:0] diff;
reg borrow;

always @(*)
begin
    // Perform subtraction A - B
    {borrow, diff[2:0]} = A - B;
    
    // Determine the comparison results based on the subtraction outcome
    if (borrow == 0) begin
        // If no borrow, A is greater than or equal to B
        if (diff == 3'b0) begin
            // If difference is zero, A is equal to B
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end else begin
            // If difference is not zero and no borrow, A is greater than B
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end else begin
        // If there's a borrow, A is less than B
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule