module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [2:0] diff;
reg sign;

always @(*) begin
    // Perform subtraction to determine the relationship between A and B
    diff = A - B;
    
    // Check the sign of the result to determine the output
    sign = diff[2]; // Assuming 2's complement representation
    
    // Determine the output based on the sign of the result
    if (sign == 1'b0 && diff != 3'b0) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (diff == 3'b0) begin
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