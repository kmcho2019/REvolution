module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

    // Perform subtraction A - B
    wire [3:0] result;
    wire borrow;

    assign {borrow, result} = A - B;

    // Determine A_greater, A_equal, and A_less
    always @(*) begin
        if (borrow) begin
            // A is less than B
            A_greater = 1'b0;
            A_equal = 1'b0;
            A_less = 1'b1;
        end else if (result == 4'b0) begin
            // A is equal to B
            A_greater = 1'b0;
            A_equal = 1'b1;
            A_less = 1'b0;
        end else begin
            // A is greater than B
            A_greater = 1'b1;
            A_equal = 1'b0;
            A_less = 1'b0;
        end
    end

endmodule