module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    // Assume A is not greater than, equal to, or less than B initially
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;

    if (A > B) begin
        // If A is greater than B, set A_greater to 1
        A_greater = 1'b1;
    end else if (A == B) begin
        // If A is equal to B, set A_equal to 1
        A_equal = 1'b1;
    end else begin
        // If A is less than B, set A_less to 1
        A_less = 1'b1;
    end
end

endmodule