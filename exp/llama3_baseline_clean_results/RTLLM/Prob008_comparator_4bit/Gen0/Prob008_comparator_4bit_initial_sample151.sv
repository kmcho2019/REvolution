module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

integer result;

always @(*) begin
    result = A - B;
    
    // If result is positive, A is greater than B
    if (result > 0) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
    
    // If result is zero, A is equal to B
    else if (result == 0) begin
        A_greater = 1'b0;
        A_equal = 1'b1;
        A_less = 1'b0;
    end
    
    // If result is negative, A is less than B
    else begin
        A_greater = 1'b0;
        A_equal = 1'b0;
        A_less = 1'b1;
    end
end

endmodule