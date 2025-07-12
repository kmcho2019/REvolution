module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // Check for equality
    if (A == B) begin
        A_equal = 1'b1;
        A_greater = 1'b0;
        A_less = 1'b0;
    end
    // If not equal, check for greater-than
    else if (A > B) begin
        A_greater = 1'b1;
        A_equal = 1'b0;
        A_less = 1'b0;
    end
    // If neither equal nor greater-than, then A is less than B
    else begin
        A_less = 1'b1;
        A_equal = 1'b0;
        A_greater = 1'b0;
    end
end

endmodule