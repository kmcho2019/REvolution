module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    // Determine the comparison result
    if (A > B) begin
        // Update outputs if A is greater than B
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (A == B) begin
        // Update outputs if A is equal to B
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end else begin
        // Update outputs if A is less than B
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule