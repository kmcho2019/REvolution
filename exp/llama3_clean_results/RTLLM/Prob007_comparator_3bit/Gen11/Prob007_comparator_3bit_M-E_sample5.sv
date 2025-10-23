module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

reg [2:0] diff;

always @(*)
begin
    // Perform subtraction to compare A and B
    diff = A - B;
    
    // Determine the relationship based on the subtraction result
    if (diff > 0) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end else if (diff == 0) begin
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