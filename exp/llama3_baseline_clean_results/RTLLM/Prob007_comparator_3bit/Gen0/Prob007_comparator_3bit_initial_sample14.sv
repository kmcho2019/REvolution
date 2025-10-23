module comparator_3bit(
    input  [2:0] A,  // First 3-bit input operand
    input  [2:0] B,  // Second 3-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Compare A and B
always @(A or B) begin
    if (A > B) begin
        A_greater = 1'b1;
        A_equal   = 1'b0;
        A_less    = 1'b0;
    end else if (A == B) begin
        A_greater = 1'b0;
        A_equal   = 1'b1;
        A_less    = 1'b0;
    end else begin
        A_greater = 1'b0;
        A_equal   = 1'b0;
        A_less    = 1'b1;
    end
end

endmodule