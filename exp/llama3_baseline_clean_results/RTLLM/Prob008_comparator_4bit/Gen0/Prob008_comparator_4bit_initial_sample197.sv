module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

// Perform subtraction and analyze borrow
wire [4:0] diff;
assign diff = {1'b0, A} - {1'b0, B};

always @(*) begin
    // If no borrow occurs and the result is non-zero, A is greater than B
    if (diff[4] == 0 && diff[3:0] != 0) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
    // If a borrow occurs, A is less than B
    else if (diff[4] == 1) begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
    // If no borrow occurs and the result is zero, A is equal to B
    else begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end
end

endmodule