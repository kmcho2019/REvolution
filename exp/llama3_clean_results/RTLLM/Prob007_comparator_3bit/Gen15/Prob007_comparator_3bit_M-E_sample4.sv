module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

wire [2:0] diff_AB; // Difference A - B
wire borrow_AB;    // Borrow out from A - B
wire [2:0] diff_BA; // Difference B - A
wire borrow_BA;    // Borrow out from B - A

// Perform subtraction operations
assign {borrow_AB, diff_AB} = A - B;
assign {borrow_BA, diff_BA} = B - A;

always @(*)
begin
    // Determine the comparison result based on subtraction outcomes
    if (borrow_AB == 1'b0 && borrow_BA == 1'b1) begin
        // A is greater than B
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (borrow_AB == 1'b1 && borrow_BA == 1'b0) begin
        // A is less than B
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end else begin
        // A is equal to B (no borrow in either direction, or both directions have borrow)
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end
end

endmodule