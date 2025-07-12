module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*)
begin
    // Initialize all outputs to 0
    A_greater = 1'b0;
    A_equal = 1'b0;
    A_less = 1'b0;
    
    // Check if A is equal to B
    if (A == B) begin
        A_equal = 1'b1;
    end else if (A > B) begin
        // If A is not equal to B and greater than B, set A_greater to 1
        A_greater = 1'b1;
    end else begin
        // If A is neither equal to nor greater than B, it must be less than B
        A_less = 1'b1;
    end
end

endmodule